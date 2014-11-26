# == Schema Information
#
# Table name: cards
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  token      :string(255)
#  nickname   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :integer
#

require 'spec_helper'

describe Card do
end