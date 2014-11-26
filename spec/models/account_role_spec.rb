# == Schema Information
#
# Table name: account_roles
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  account_id :integer
#  role       :string(255)      default("member")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe AccountRole do
  let(:account_role) { create(:account_role) }
  it "has a valid factory" do
    account_role.should be_valid
  end

  it "should have association with user" do
    should belong_to(:user)
  end

  it "should have association with account" do
    should belong_to(:account)
  end

  it "is invalid without a user_id" do
    new_account_role = build(:account_role, user_id: nil)
    new_account_role.should_not be_valid
    new_account_role.errors.messages[:user_id].should be_include "can't be blank"
  end

  it "is invalid without an account_id" do
    new_account_role = build(:account_role, account_id: nil)
    new_account_role.should_not be_valid
    new_account_role.errors.messages[:account_id].should be_include "can't be blank"
  end

  it "should have unique combination of account_id and user_id" do
    should validate_uniqueness_of(:account_id).scoped_to(:user_id)
  end
  
  it "should have 'join date' same as 'created at'" do
    account_role.join_date.should be account_role.created_at
  end

end
