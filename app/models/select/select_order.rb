# == Schema Information
#
# Table name: select_orders
#
#  id                    :integer          not null, primary key
#  user_id               :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  select_event_id       :integer
#  status                :string(255)
#  subtotal_amount_cents :integer
#  gratuity_amount_cents :integer
#  delivery_amount_cents :integer
#  tax_amount_cents      :integer
#  total_amount_cents    :integer
#  edit_mode             :boolean          default(FALSE)
#  subsidy_amount_cents  :integer
#

class Select::SelectOrder < ActiveRecord::Base
  belongs_to :select_event
  belongs_to :user

  has_many :select_order_items, dependent: :destroy
  has_many :select_order_transactions

  before_validation :ensure_order_can_be_saved
  before_save :recalc_totals_for_save
  after_save :provision_adjustment_items

  monetize :subtotal_amount_cents
  monetize :gratuity_amount_cents
  monetize :delivery_amount_cents
  monetize :tax_amount_cents
  monetize :subsidy_amount_cents
  monetize :total_amount_cents

  after_initialize :initial_values

  # Called after_commit for select_order_items
  def recalc_totals item_status = :current
    # Calculate subtotal based on the item_status passed in (defaults to :current)
    
    running_total = Money.new(0)
    subtotal_amount = Money.new(order_subtotal(item_status))

    running_total = subtotal_amount

    # Calculate delivery amount (based on the select event?)
    delivery_amount = Money.new(65)
    running_total += delivery_amount

    # Calculate gratuity 
    gratuity_amount = calc_gratuity(running_total)
    running_total += gratuity_amount

    # Calculate tax amount: subtotal + gratuity 
    tax_amount = calc_tax(running_total)
    running_total += tax_amount
   
    # Update total
    total_amount = running_total

    # Subsidy
    subsidy_amount = subsidy total_amount
    total_amount -= subsidy_amount

    # Return values to caller
    {subtotal_amount_cents: subtotal_amount,
     gratuity_amount_cents: gratuity_amount,
     delivery_amount_cents: delivery_amount,
     tax_amount_cents: tax_amount,
     subsidy_amount_cents: subsidy_amount,
     total_amount_cents: total_amount}
  end

  def order_subtotal item_status
    self.select_order_items.where(status: item_status).map{|ii| ii.quantity * ii.unit_price_cents}.sum
  end

  def calc_gratuity adjusted_subtotal
    Money.new(adjusted_subtotal * self.select_event.default_gratuity)
  end

  def calc_tax adjusted_subtotal
    tax_rate = self.select_event.market_tax_rate
    Money.new(adjusted_subtotal * tax_rate)
  end

  def subsidy adjusted_subtotal
    subsidy_amount = Money.new(0)

    case self.select_event.subsidy
    when "percentage"
      subsidy_amount = Money.new(adjusted_subtotal * self.select_event.subsidy_percentage_cap)
      if self.select_event.is_subsidy_percentage_capped and ( subsidy_amount  > self.select_event.subsidy_percentage_fixed_amount_cap )
        subsidy_amount = self.select_event.subsidy_percentage_fixed_amount_cap
      end
    when "fixed_amount"
      subsidy_amount = self.select_event.subsidy_fixed_amount
    when "fully_subsidized"
      subsidy_amount = adjusted_subtotal
    end

    subsidy_amount
  end

  def initial_values
    self.subtotal_amount_cents  ||= 0
    self.gratuity_amount_cents  ||= 0
    self.delivery_amount_cents  ||= 0
    self.total_amount_cents    ||= 0
    self.tax_amount_cents      ||= 0
    self.subsidy_amount_cents  ||= 0
  end


  # -----------------------------------------
  # Notes on status values for select orders:
  # -----------------------------------------
  # cart              : In the cart - can be freely edited by
  #                     user (select/user-facing engine) or by
  #                     admin user (snappea).
  # checkout          : On the checkout page. The user (select
  #                     engine) has gone to the checkout page
  #                     but has not placed the order.
  # checkout_complete : Checkout completed, payment has been
  #                     authorized by Braintree (select engine).
  # canceled          : Canceled by user (select engine) or
  #                     admin user (snappea)
  # pending           : Select event is closed:
  #                     * No new orders allowed;
  #                     * No edits to existing orders;
  #                     * Manifests have been generated;
  #                     * All select orders in :checkout_complete
  #                       are switched to :pending
  # completed         : "Food is delivered" email has been sent.
  #                     * Submit all authorized transactions for settlement
  # system_canceled   : Order is canceled by cron job
  #                     * All select orders for this event in :cart
  #                       or :checkout state are cleaned-up on
  #                       end-of-day cron job.
  # -----------------------------------------

  def editing?
    if Time.now > self.select_event.ordering_window_end_time
      # Cutoff time has passed
      false
    elsif self.edit_mode
      # SnapPea user is editing this select order
      true
    else
      # Default => not editing since the edit_mode field isn't set
      false
    end
  end

  def payment_or_refund_amount
    amount_current = self.recalc_totals :current
    amount_provisioned = self.recalc_totals :provisioned
    amount_provisioned[:total_amount_cents] - amount_current[:total_amount_cents]
  end

  # Cancel an existing order
  # Void/refund all associated payments
  # Set order status to :canceled
  def cancel status=:canceled
    result = true

    # Refund all transactions associated with order
    self.select_order_transactions.payments.each do |t|
      result = self.braintree_refund_transaction t
    end

    # Mark the order as canceled if all braintree refunds succeeded
    if result
      self.edit_mode = false
      self.status = status
      self.save
    end

    # Return result
    result
  end

  # Mark editing complete for an existing order
  # Optionally set order status if supplied
  def editing_complete status=nil
    self.edit_mode = false
    self.status = status.to_s if status
    self.save
  end

  # Create a new sale & save it as a select order transaction
  # -------------------------------------------------------------------
  # card: an optional Card object
  #       if NOT nil, then only params[:amount] is used
  #
  # If card is nil then:
  # params: {
  #   :amount => dollar amount (eg: 104.68)
  #   :number => credit card number (client-side encrypted)
  #   :cvv => credit card cvv code (client-side encrypted)
  #   :expiration_month => credit card expiration month
  #   :expiration_year => credit card expiration year
  # }
  #
  # Optional params: {
  #   :account_id => account id
  #   :notes => notes to store in the select order transaction table
  #   :customer_id => braintree customer id (TODO: where do we get this?)
  # }
  def braintree_sale card, params
    if card
      # Create a new transaction based on a saved card
      result = Braintree::Transaction.sale(
                  payment_method_token: card.token,
                  amount: params[:amount],
                )
    else
      # Create a new transaction based on a passed in card
      result = Braintree::Transaction.sale(
                  amount: params[:amount],
                  credit_card: {
                    number: params[:number],
                    cvv: params[:cvv],
                    expiration_month: params[:expiration_month],
                    expiration_year:  params[:expiration_year]
                  }
                )
    end

    result_data = self.braintree_result_data result

    # Create the select order transaction row
    t = Select::SelectOrderTransaction.create(
            # Snappea data
            user_id:          user.id,
            select_event_id:  self.select_event.id,
            select_order_id:  self.id,
            card_id:          (card ? card.id : nil),
            account_id:       params[:account_id],
            timestamp:        Time.now,
            amount:           params[:amount],
            is_refund:        false,
            notes:            params[:notes],
            # Braintree data
            superceded:       false,
            customer_id:      params[:customer_id],
            transaction_id:   result_data[:transaction_id],
            transaction_type: result_data[:transaction_type],
            status:           result_data[:status],
            response:         result_data[:response],
            # Metadata
            cc_last4:         result_data[:cc_last4],
            card_type:        result_data[:card_type],
            expiration_date:  result_data[:expiration_date]
          )

    # Return true if successful
    result.success?
  end

  # Partially refund an existing sale & save it as a new select order transaction
  # Or issue a complete refund if the transaction id is passed in and the amounts
  # are the same (i.e., params[amount] == transaction.amount)
  # -----------------------------------------------------------------------------
  # params: {
  #   :amount => dollar amount (eg: 104.68)
  # }
  #
  # Optional params: {
  #   :select_order_transaction_id => original transaction id (of pay-in)
  #   :account_id => account id
  #   :notes => notes to store in the select order transaction table
  #   :customer_id => braintree customer id (TODO: where do we get this?)
  # }
  #
  def braintree_refund params
    ret_val = true

    refund_amount = params[:amount].to_f

    if params[:select_order_transaction_id]
      # Transaction id has been passed in
      orig_transaction = Select::SelectOrderTransaction.find_by_id params[:select_order_transaction_id]
      return false if !orig_transaction or orig_transaction.is_refund
      # If the amounts are identical cancel the transaction itself
      # refund that transaction and return
      if refund_amount == orig_transaction.amount
        return self.braintree_refund_transaction orig_transaction
      end
      # Otherwise fall thru, the transaction id supplied is ignored
      # only the amount is used.
    end

    # No transaction id, just amount available so this refund may involve
    # one or more transactions that need to be reversed
    self.select_order_transactions.payments.order('amount asc').each do |transaction|
      return ret_val if refund_amount <= 0.to_f
      if transaction.amount <= refund_amount
        # Found a transaction that can be completely refunded (amt <= refund_amount)
        ret_val = self.braintree_refund_transaction transaction
        refund_amount = refund_amount - transaction.amount if ret_val
      elsif (transaction.amount > refund_amount) and (refund_amount > 0.to_f)
        # Transaction amount > refund amount: special case processing
        # Deduct refund amount from this transactions' amount
        # and create a new transaction superceding this transaction
        #
        # This is used when creating the new transaction row
        # Refund is FALSE assuming that the orig transaction is not settled/settling
        transaction_refund = false

        if [:settled, :settling].include? transaction.status.to_sym
          # If the original transaction being partially refunded has already been
          # settled or is in the process of settling then we should refund the
          # amount.
          result = Braintree::Transaction.refund(transaction.transaction_id, refund_amount)
          result_data = self.braintree_result_data result
          transaction_refund = true
          ret_val = result.success?
        elsif [:authorized, :submitted_for_settlement].include? transaction.status.to_sym
          # If the original transaction is just authorized or submitted for settlement
          # do nothing at this point (we've authorized a higher dollar amount than what
          # is going to be charged).
          # Set the result_data based on the orig transaction about to be superceded.
          result_data = {
            transaction_id:   transaction.transaction_id,
            transaction_type: transaction.transaction_type,
            status:           transaction.status,
            response:         transaction.response,
            cc_last4:         transaction.cc_last4,
            card_type:        transaction.card_type,
            expiration_date:  transaction.expiration_date
          }
          ret_val = true
        end

        if result_data[:transaction_id] and (transaction.amount - refund_amount) > 0.to_f
          # Create the select order transaction row only to record a non-zero amount
          # The refund of a full transaction resulting in a zero left-over amount
          # does not need an updated transaction row.
          t = Select::SelectOrderTransaction.create(
                  # Snappea data
                  user_id:          user.id,
                  select_event_id:  self.select_event.id,
                  select_order_id:  self.id,
                  card_id:          (transaction_refund ? nil : transaction.card_id),
                  account_id:       (transaction_refund ? nil : transaction.account_id),
                  timestamp:        Time.now,
                  amount:           (transaction.amount - refund_amount),
                  is_refund:        transaction_refund,
                  notes:            (transaction_refund ? params[:notes] : transaction.notes),
                  # Braintree data
                  superceded:       false,
                  customer_id:      nil,                      # TODO
                  transaction_id:   result_data[:transaction_id],
                  transaction_type: result_data[:transaction_type],
                  status:           result_data[:status],
                  response:         result_data[:response],
                  # Metadata
                  cc_last4:         result_data[:cc_last4],
                  card_type:        result_data[:card_type],
                  expiration_date:  result_data[:expiration_date]
                )

          if !transaction_refund
            # Update the existing transaction, set superceded to TRUE
            # only if the amount is being adjusted BEFORE settlement
            # (otherwise the previous transaction data stays as is)
            transaction.update_attributes({
              superceded: true,
              notes:      transaction.notes + "; Superceded by transaction: " + t.id.to_s
            })
          end
        end
        # Complete amount has been refunded using this transaction
        # So we can return back to caller
        return ret_val
      end
    end

    # Return the status back (true = all ok)
    ret_val
  end


  protected

    def recalc_totals_for_save
      if !self.edit_mode and Time.now < self.select_event.ordering_window_end_time
        # Totals recalculated & updated only when:
        # a) if within order window end time
        # b) edit_mode = false
        #    i.e., edit_mode is changing from TRUE => FALSE
        #    Since this happens before the provision adjustment, we should
        #    recalculate based on the existing provisioned items
        totals = self.recalc_totals :provisioned
        # Set the values to save

        self.subtotal_amount_cents = totals[:subtotal_amount_cents]
        self.gratuity_amount_cents = totals[:gratuity_amount_cents]
        self.delivery_amount_cents = totals[:delivery_amount_cents]
        self.subsidy_amount_cents  = totals[:subsidy_amount_cents]
        self.tax_amount_cents = totals[:tax_amount_cents]
        self.total_amount_cents = totals[:total_amount_cents]
      end
    end

    def provision_adjustment_items
      if Time.now > self.select_event.ordering_window_end_time
        # Cutoff time has passed
        false
      elsif self.edit_mode
        # Order edit_mode state change: FALSE => TRUE
        # == snappea user has started adjustment ==
        # 1. Whack all previous :provisioned line items
        # 2. Recreate new :provisioned line items
        self.select_order_items.where(status: :provisioned).destroy_all
        self.select_order_items.where(status: :current).each do |item|
          # Set up select_order_item
          dup_item = item.dup
          dup_item.status = :provisioned
          dup_item.save   # Save first time (without options to get an id)
          # Set up associated options
          dup_item_options = []
          item.select_order_item_options.each do |item_option|
            dup_item_option = item_option.dup
            dup_item_option.select_order_item_id = dup_item.id  # Use the dup items id here
            dup_item_option.save
            dup_item_options << dup_item_option
          end
          # For recalculating prices re-save after associating the options
          dup_item.select_order_item_options = dup_item_options
          dup_item.save
        end
      else
        # Order edit_mode state change: TRUE => FALSE
        # == snappea user has completed adjustment ==
        # 1. Whack all previous :current line items
        # 2. Update all :provisioned line items to :current
        self.select_order_items.where(status: :current).destroy_all
        self.select_order_items.where(status: :provisioned).each do |item|
          item.status = :current
          item.save
        end
      end
    end

    def ensure_order_can_be_saved
      if Time.now > self.select_event.ordering_window_end_time
        errors.add :base, 'Ordering time window has ended "' + self.select_event.ordering_window_end_time.to_s + '"'
        false
      elsif !self.status
        errors.add :base, 'Order does not have valid status field data'
        false
      elsif [:cart, :checkout].include? self.status.to_sym
        true
      elsif [:checkout_complete, :canceled].include? self.status.to_sym and (user.is_admin? self.select_event.account.id or user.id == self.user_id)
        true
      else
        errors.add :base, 'Only admin users can mark order status "' + self.status.to_s + '"'
        false
      end
    end

    # Refund an existing transaction & save it as a new select order transaction
    # --------------------------------------------------------------------------
    # transaction => the transaction to refund or void
    #
    def braintree_refund_transaction transaction
      if transaction and !transaction.is_refund and !transaction.superceded
        # Attempt to refund the requested amount
        if [:settled, :settling].include? transaction.status.to_sym
          result = Braintree::Transaction.refund(transaction.transaction_id, amount)
        elsif [:authorized, :submitted_for_settlement].include? transaction.status.to_sym
          result = Braintree::Transaction.void(transaction.transaction_id)
        else
          # Cannot handle the current transaction state
          return false
        end

        result_data = self.braintree_result_data result

        if result_data[:transaction_id]
          # Create the select order transaction row
          t = Select::SelectOrderTransaction.create(
                  # Snappea data
                  user_id:          user.id,
                  select_event_id:  self.select_event.id,
                  select_order_id:  self.id,
                  card_id:          nil,      # TODO
                  account_id:       nil,      # TODO
                  timestamp:        Time.now,
                  amount:           transaction.amount,
                  is_refund:        true,
                  notes:            transaction.notes,
                  # Braintree data
                  superceded:       false,
                  customer_id:      nil,      # TODO
                  transaction_id:   result_data[:transaction_id],
                  transaction_type: result_data[:transaction_type],
                  status:           result_data[:status],
                  response:         result_data[:response],
                  # Metadata
                  cc_last4:         result_data[:cc_last4],
                  card_type:        result_data[:card_type],
                  expiration_date:  result_data[:expiration_date]
                )

          # Update the existing transaction by superceding it
          transaction.update_attributes({
            superceded: true,
            notes:      transaction.notes + "; Superceded by transaction: " + t.id.to_s
          })
        end

        # Return true if successful
        result.success?
      else
        # No such transaction id
        false
      end
    end

    def braintree_result_data result
      transaction = result.transaction
      status = nil

      if result.success?
        response = :success
        status = transaction.status
      else
        response = ''
        if transaction and transaction.processor_response_code
          response = '(' + transaction.processor_response_code + ') ' + transaction.processor_response_text
          status = transaction.status
        elsif transaction and transaction.gateway_rejection_reason
          response = 'Gateway rejection: ' + transaction.gateway_rejection_reason
          status = transaction.status
        end
      end

      { transaction_id:   (transaction ? transaction.id   : nil),
        transaction_type: (transaction ? transaction.type : nil),
        cc_last4:         (transaction ? transaction.credit_card_details.last_4 : 'XXXX'),
        card_type:        (transaction ? transaction.credit_card_details.card_type : '?'),
        expiration_date:  (transaction ? transaction.credit_card_details.expiration_date  : 'MM/YYYY'),
        status:           status,
        response:         response }
    end

end
