# == Schema Information
#
# Table name: payment_histories
#
#  id               :integer          not null, primary key
#  event_id         :integer
#  transaction_id   :string(255)
#  cc_last4         :string(255)
#  customer_id      :string(255)
#  status           :string(255)
#  amount           :float
#  transaction_type :string(255)
#  timestamp        :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :integer
#  is_latest        :boolean
#  card_type        :string(255)
#  nickname         :string(255)
#  exp_date         :string(255)
#

class PaymentHistory < ActiveRecord::Base
  belongs_to :event
  belongs_to :user

  def self.update_history(event, transaction, user = nil)
    braintree_history = transaction.status_history
    cc = transaction.credit_card_details
    custom_transaction_id = transaction.custom_fields[:custom_transaction_id]
    event_transaction = EventTransaction.find_or_create_by_event_id_and_transaction_id(event.id, transaction.id)
    event_transaction.update_attributes(status: transaction.status, amount: transaction.amount, transaction_type: transaction.type)
    braintree_history.each do |bh|
      history = find(custom_transaction_id) if custom_transaction_id
      history = find_or_create_by_event_id_and_transaction_id_and_status(event.id, transaction.id, bh.status) unless history.try(:status) == "requested"
      history.update_attributes(cc_last4: cc.last_4, customer_id: transaction.customer_details.id, timestamp: bh.timestamp, 
                                amount: bh.amount, is_latest: event_transaction.status == bh.status, user_id: user, 
                                transaction_type: transaction.type, card_type: cc.card_type, exp_date: cc.expiration_date, 
                                nickname: Card.find_by_token(cc.token).try(:nickname), status: bh.status, transaction_id: transaction.id)
    end
  end
  
  def self.record_errors(event, errors=[], user, trans_id, card)
    error_description = errors.map{|e| "(#{e.code}) #{e.message})"}.join(', ')
    error_codes = errors.map(&:code).join(', ')
    error_messages = errors.map(&:message).join(', ')
    title = 'Braintree Transaction Failed'
    description = "There was an issue with a transaction on an event ID: #{event.id} that requires your attention.<br><br>Details:<br>Code: #{error_codes}<br>Message: #{error_messages}<br><br>-SnapPea"
    Notifier.send_transaction_failure_report(title, description).deliver
    if trans_id
      transaction = Braintree::Transaction.find trans_id
      cc = transaction.credit_card_details
      update_history(event, transaction, user)
    else
      cc = Braintree::CreditCard.find card
      customer = Braintree::Customer.find cc.customer_id
      create(event_id: event.id, status: error_description, cc_last4: cc.last_4, customer_id: customer.id, 
             timestamp: DateTime.now, user_id: user, card_type: cc.card_type, exp_date: cc.expiration_date, 
             nickname: Card.find_by_token(cc.token).try(:nickname))
    end
    event.issues.create(title: title, 
                        description: description, 
                        priority: 'High', due_date: Date.today.next_business_day.to_datetime, assignee_id: event.event_owner_id, assigner_id: user)
  end

  def self.create_dummy_history event_id, user_id, token, amount
    cc = Braintree::CreditCard.find(token)
    PaymentHistory.create(event_id: event_id, user_id: user_id, cc_last4: cc.last_4, card_type: cc.card_type,
                          customer_id: cc.customer_id, status: "requested", amount: amount, exp_date: cc.expiration_date,
                          nickname: Card.find_by_token(cc.token).nickname, timestamp: Time.now)
  end

end
