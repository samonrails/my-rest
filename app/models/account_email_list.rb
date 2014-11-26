# == Schema Information
#
# Table name: account_email_lists
#
#  id         :integer          not null, primary key
#  account_id :integer
#  list_id    :string(255)
#

class AccountEmailList < ApplicationModel
  belongs_to :account

  validates_presence_of :account_id
  

end
