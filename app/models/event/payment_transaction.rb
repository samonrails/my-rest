module Event::PaymentTransaction

  def new_transaction(card, amount, settle, user, custom_transaction_id)
    result = create_new_transaction(card, amount, settle, custom_transaction_id)
    maintain_history(result, self, user, nil, card)
  end

  def settle_transaction(trans_id, amount, user)
    transaction = Braintree::Transaction.find trans_id
    if amount.to_f <= transaction.amount
      result = Braintree::Transaction.submit_for_settlement(trans_id, amount)
    else
      voided = Braintree::Transaction.void(trans_id)
      maintain_history(voided, self, user, nil, trans_id)
      result = create_new_transaction(transaction.credit_card_details.token, amount) if voided.success?
    end
    maintain_history(result, self, user, trans_id)
  end

  def void_transaction(trans_id, user)
    result = Braintree::Transaction.void trans_id
    maintain_history(result, self, user, trans_id)
  end

  def refund_transaction(trans_id, amount, user)
    result = Braintree::Transaction.refund(trans_id, amount)
    maintain_history(result, self, user, trans_id)
  end

  private

  def create_new_transaction(card, amt, settle = true, custom_transaction_id)
    if Figaro.env.has_key? "braintree_merchant_account_id"
      Braintree::Transaction.sale(amount: amt, 
                                  payment_method_token: card, 
                                  merchant_account_id: Figaro.env.braintree_merchant_account_id, 
                                  options: {submit_for_settlement: settle}, 
                                  custom_fields: {custom_transaction_id: custom_transaction_id},
                                  order_id: self.id)
    else
      Rails.logger.error "Braintree Merchant account is not definned. Using the default."
      Braintree::Transaction.sale(amount: amt, 
                                  payment_method_token: card, 
                                  options: {submit_for_settlement: settle}, 
                                  custom_fields: {custom_transaction_id: custom_transaction_id},
                                  order_id: self.id)
    end
  end

  def maintain_history(result, event, user, trans_id = nil, card = nil)
    if result.success?
      PaymentHistory.update_history(event, result.transaction, user)
    else
      PaymentHistory.record_errors(event, result.errors, user, result.transaction.id, card) if result.transaction
      PaymentHistory.record_errors(event, result.errors, user, trans_id, card) unless result.transaction
    end
  end

end