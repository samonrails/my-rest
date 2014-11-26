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

require 'spec_helper'

describe PaymentHistory do
end