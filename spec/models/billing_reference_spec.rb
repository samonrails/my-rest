# == Schema Information
#
# Table name: billing_references
#
#  id         :integer          not null, primary key
#  account_id :integer
#  name       :string(255)
#  event_id   :integer
#  required   :boolean          default(FALSE)
#  data       :text
#  deleted_at :datetime
#

require "spec_helper"

describe BillingReference do

  let (:billing_reference) { create(:billing_reference_for_account) }

  it 'should have associations with account and event' do
    billing_reference.should belong_to(:account)
    billing_reference.should belong_to(:event)
  end

  it 'is invalid without name' do
    br = FactoryGirl.build(:billing_reference_for_account, name: "")
    expect(br.valid?).to be false
  end

  it 'should have serialize data attribute which is an array' do
    expect(billing_reference[:data].class).to be Array
  end

  it 'should have a setter for data that saves it in form of Array' do
    br = FactoryGirl.create(:billing_reference_for_account, data: 'Element1\r\nElement2\r\nElement3')
    expect(br[:data].class).to be Array
  end

  it 'should have a getter for data that render data for textarea' do
    br = FactoryGirl.create(:billing_reference_for_account)
    expect(br.data.class).to be String
  end

  it 'should have an instance method to represent data attribute in human readbale form' do
    br = FactoryGirl.create(:billing_reference_for_account)
    expect(br.data.class).to be String
    expect(br.humanized_data).to eq br[:data].join(', ')
  end
  
  it 'should have a class method that return all billing references in a hash' do
    brs = BillingReference.as_tag_list_with_name
    expect(brs.class).to be Hash
  end
end
