class Select::SelectOrdersController < ApplicationController

  def create
    user_id = params[:select_order][:user].to_i unless params[:select_order][:user].nil?
    select_event_id = params[:select_order][:select_event_id].to_i unless params[:select_order][:select_event_id].nil?
    new_order = Select::SelectOrder.create(user_id: user_id, select_event_id: select_event_id, status: params[:select_order][:status], edit_mode: true)
    if new_order.id
      redirect_to select_select_order_path(new_order)
    else
      flash[:error] = "Error creating select order - " + new_order.errors.full_messages.join(", ")
      redirect_to select_event_path(new_order.select_event_id)
    end
  end

  def update
    @select_order = Select::SelectOrder.find(params[:id])
    if (!@select_order.editing? and permitted_params.select_order[:edit_mode] == 'true') or (@select_order.editing? and permitted_params.select_order[:edit_mode] == 'false')
      if @select_order.update_attributes(permitted_params.select_order)
        flash[:notice] = "Select order adjustment " + (@select_order.editing? ? "started" : "completed")
      else
        flash[:error] = "Error adjusting select order - " + @select_order.errors.full_messages.join(", ")
      end
    end
    redirect_to select_select_order_path(@select_order)
  end

  def show
    @select_order = Select::SelectOrder.find(params[:id])
    @select_event = @select_order.select_event
    @vendors = @select_event.vendors
    @menu_templates = @select_event.menu_templates
    @inventory_items = {}
    @vendors.each do |v|
      @inventory_items[v.id] = {}
    end
    # If there aren't any menu templates associated with the vendor, don't loop thru
    if @menu_templates
      @menu_templates.each do |menu_template|
        menu_template.inventory_items.order(:name_public).each do |inventory_item|
          @inventory_items[menu_template.vendor_id][inventory_item.id] = inventory_item.name_public if !inventory_item.inventory_item_option
        end
      end
    end
  end

  def new_transaction
    @select_order = Select::SelectOrder.find params[:select_order_id]

    the_partial = "select/select_orders/transactions/no_transaction"
    the_locals = {select_order: @select_order}

    # If the amount for adjusted order (provisioned items) is > current
    # then we're processing a payment
    total_amount_cents = @select_order.payment_or_refund_amount

    if total_amount_cents > 0
      # Payment is due
      the_partial = "select/select_orders/transactions/payment"
      the_locals[:payment_amount] = total_amount_cents
      the_locals[:cards]          = @select_order.user.cards
    elsif total_amount_cents < 0
      # Refund is due
      the_partial = "select/select_orders/transactions/refund"
      the_locals[:refund_amount] = -1 * total_amount_cents
    end

    render partial: the_partial, locals: the_locals
  end

  def adjust
    # Assume everything's A-OK
    result = true

    @select_order = Select::SelectOrder.find params[:select_order_id]

    card_id = permitted_params.select_order_transaction[:card_id]
    is_refund = permitted_params.select_order_transaction[:is_refund].to_bool
    amount = permitted_params.select_order_transaction[:amount].to_f.to_money
    send_receipt = permitted_params.select_order_transaction[:send_receipt].to_bool

    result = false if @select_order.nil?

    # Sanity checks on data
    if card_id and result
      card = Card.find_by_id card_id
      if card.nil?
        result = false
        flash[:error] = "Invalid card with id " + card_id.to_s + ". Transaction not created."
      end
    end

    # Sanity checks on amount
    total_amount_cents = @select_order.payment_or_refund_amount
    create_transaction = (total_amount_cents != 0)

    if total_amount_cents < 0 and is_refund and ((total_amount_cents * -1) != amount.cents)
      result = false
      flash[:error] = "Invalid amount specified for refund " + sprintf("$%.02f", amount) + ". Transaction not created."
    elsif total_amount_cents > 0 and !is_refund and (total_amount_cents != amount.cents)
      result = false
      flash[:error] = "Invalid amount specified for charge " + sprintf("$%.02f", amount) + ". Transaction not created."
    elsif amount.cents <= 0
      result = false
      flash[:error] = "Invalid amount specified for transaction " + sprintf("$%.02f", amount) + ". Transaction not created."
    end

    # Create the transaction if required
    if create_transaction and result
      braintree_transaction = '';
      if is_refund
        # Is a refund, need to create a transaction
        result = @select_order.braintree_refund permitted_params.select_order_transaction
        braintree_transaction = 'refund'
      else
        # Is a sale, need to create a transaction
        result = @select_order.braintree_sale card, permitted_params.select_order_transaction
        braintree_transaction = 'payment'
      end
      flash[:error] = "Unable to create a braintree transaction for " + braintree_transaction if !result
    end

    # Close the edit mode of the current order if transactions etc are successful
    if result
      # Braintree transaction was successful, now mark order as editing complete
      result = @select_order.editing_complete (result ? :checkout_complete : nil)
      flash[:error] = "Error adjusting select order - " + @select_order.errors.full_messages.join(", ") if !result
    end

    # Send out the updated receipt after the updated data is saved
    if send_receipt and result
      # TODO: @select_order.email_receipt
    end

    redirect_to select_select_order_path(@select_order)
  end

end
