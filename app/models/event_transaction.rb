# == Schema Information
#
# Table name: event_transactions
#
#  id               :integer          not null, primary key
#  event_id         :integer
#  transaction_id   :string(255)
#  status           :string(255)
#  amount           :float
#  transaction_type :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class EventTransaction < ActiveRecord::Base
  belongs_to :event

  scope :authorized, lambda{ where(status: 'authorized')}
  scope :unsettled, lambda{ where(status: 'submitted_for_settlement')}
  scope :voidable_transactions, lambda{ where(status: %w{authorized submitted_for_settlement})}
  scope :refundable_transactions, lambda{ where(status: %w{settling settled})}

  def check_for_settling
    trans = Braintree::Transaction.find(transaction_id)
    PaymentHistory.update_history(event, trans)
  end
end
