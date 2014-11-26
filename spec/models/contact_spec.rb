# == Schema Information
#
# Table name: contacts
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  position               :string(255)
#  email                  :string(255)
#  phone_number           :string(255)
#  mobile_number          :string(255)
#  fax_number             :string(255)
#  primary_contact        :boolean
#  billing_notifications  :boolean
#  event_notifications    :boolean
#  sms                    :boolean
#  account_id             :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  vendor_id              :integer
#  feedback_notifications :boolean          default(TRUE)
#  user_id                :integer
#  contact_type           :string(255)      default("Internal")
#  self_created           :boolean          default(FALSE)
#  deleted_at             :datetime
#

require 'spec_helper'

describe Contact do
  let (:contact) { create(:contact) }

  it "should be valid" do
    contact.should be_valid
  end

  it "should require a name" do
    build(:contact, name: nil).should_not be_valid
  end

  it "should require a non empty name" do
    build(:contact, name: "").should_not be_valid
  end

end
