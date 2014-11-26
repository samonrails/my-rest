class Select::SelectOrderTransactionsController < ApplicationController

  def refund
    transaction = Select::SelectOrderTransaction.find params[:select_order_transaction_id]

    if transaction.nil? or transaction.is_refund or transaction.superceded
      flash[:error] = "Transaction for refund, id:" + params[:select_order_transaction_id].to_i.to_s + " is invalid."
      redirect_to select_select_order_path(transaction.select_order)
    end

    render partial: "select/select_orders/transactions/refund_transaction",
           locals:  { select_order:  transaction.select_order,
                      transaction:   transaction,
                      refund_amount: transaction.amount }
  end

  def new
    @select_order = Select::SelectOrder.find params[:select_order_id]
    render partial: "select/select_orders/transactions/new",
           locals:  { select_order: @select_order,
                      cards:        @select_order.user.cards }
  end

  def create
    # Assume everything's A-OK
    result = true

    @select_order = Select::SelectOrder.find params[:select_order_id]

    card_id = permitted_params.select_order_transaction[:card_id]
    is_refund = permitted_params.select_order_transaction[:is_refund].to_bool
    amount = permitted_params.select_order_transaction[:amount].to_f.to_money
    send_receipt = permitted_params.select_order_transaction[:send_receipt].to_bool
    transaction_id = permitted_params.select_order_transaction[:select_order_transaction_id]

    result = false if @select_order.nil?

    # Sanity checks on data
    if card_id and result
      card = Card.find_by_id card_id
      if card.nil?
        result = false
        flash[:error] = "Invalid card with id " + card_id.to_s + ". Transaction not created."
      end
    end

    # Transaction id may be provided for a refund/voiding of a specific transaction
    transaction = nil
    if transaction_id
      transaction = Select::SelectOrderTransaction.find_by_id(transaction_id)
      if transaction.nil? or transaction.is_refund or transaction.superceded
        result = false
        flash[:error] = "Transaction for refund, id:" + transaction_id.to_s + " is invalid."
      end
    end

    # Sanity checks on amount, refund and transaction_id
    if amount.cents <= 0
      result = false
      flash[:error] = "Invalid amount specified for transaction " + sprintf("$%.02f", amount) + ". Transaction not created."
    elsif amount.cents > @select_order.total_amount_cents and is_refund and transaction.nil?
      result = false
      flash[:error] = "Amount specified for refund " + sprintf("$%.02f", amount) + " is higher than order total $" + Money.new(@select_order.total_amount_cents).to_s + ". Transaction not created."
    elsif is_refund and transaction and amount > transaction.amount
      result = false
      flash[:error] = "Amount " + sprintf("$%.02f", amount) + " is higher than transaction amount $" + transaction.amount + ". Transaction not created."
    end

    # Create the transaction if everything's ok
    if result
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

    # Send out the updated receipt after the updated data is saved
    if send_receipt and result
      # TODO: @select_order.email_receipt
    end

    redirect_to select_select_order_path(params[:select_order_id])
  end

  protected

end
