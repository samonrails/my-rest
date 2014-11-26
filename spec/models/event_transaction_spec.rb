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

require 'spec_helper'

describe EventTransaction do
end