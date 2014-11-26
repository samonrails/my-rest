# == Schema Information
#
# Table name: select_order_transactions
#
#  id               :integer          not null, primary key
#  select_event_id  :integer
#  select_order_id  :integer
#  card_id          :integer
#  user_id          :integer
#  account_id       :integer
#  amount           :float
#  notes            :string(255)
#  timestamp        :datetime
#  is_refund        :boolean
#  customer_id      :string(255)
#  transaction_id   :string(255)
#  transaction_type :string(255)
#  status           :string(255)
#  response         :string(255)
#  superceded       :boolean
#  cc_last4         :string(255)
#  card_type        :string(255)
#  expiration_date  :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Select::SelectOrderTransaction < ActiveRecord::Base
  belongs_to :select_event
  belongs_to :select_order
  belongs_to :card
  belongs_to :user
  belongs_to :account

  scope :authorized, lambda{ where(status: 'authorized')}
  scope :unsettled, lambda{ where(status: 'submitted_for_settlement')}
  scope :voidable_transactions, lambda{ where(status: %w{authorized submitted_for_settlement})}
  scope :refundable_transactions, lambda{ where(status: %w{settling settled})}
  scope :payments, lambda{ where({is_refund: false, superceded: false})}

end

