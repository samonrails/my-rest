# == Schema Information
#
# Table name: line_items
#
#  id                              :integer          not null, primary key
#  line_item_type                  :string(255)
#  sku                             :string(255)
#  name                            :string(255)
#  notes                           :text
#  quantity                        :integer
#  include_price_in_expense        :boolean
#  include_price_in_revenue        :boolean
#  event_id                        :integer
#  inventory_item_id               :integer
#  billable_party_type             :string(255)
#  billable_party_id               :integer
#  payable_party_type              :string(255)
#  payable_party_id                :integer
#  tax_rate_expense                :decimal(, )
#  tax_rate_revenue                :decimal(, )
#  line_item_sub_type              :string(255)
#  after_subtotal                  :boolean
#  percentage_of_subtotal          :boolean
#  document_id                     :integer
#  unit_price_expense_cents        :integer
#  unit_price_revenue_cents        :integer
#  parent_id                       :integer
#  menu_template_id                :integer
#  tax_rate_default_locked_expense :boolean          default(FALSE), not null
#  tax_rate_default_locked_revenue :boolean          default(FALSE), not null
#  add_on_parent_id                :integer
#  opposing_line_item_id           :integer
#

require 'spec_helper'

describe LineItem do
  let (:vendor){ create(:vendor) }
  let (:account){ create(:account) }
  let (:line_item) { create(:line_item)}

  it "should belong to Payable Party" do
    line_item.should belong_to(:payable_party)
  end
  it "should belong to Billable Party" do
    line_item.should belong_to(:billable_party)
  end

  context "payable party" do
    it "should be polymorphic 1" do
      line_item.payable_party = vendor;
      line_item.payable_party_id.should == vendor.id;
    end
    it "should be polymorphic 2" do
      line_item.payable_party = vendor;
      line_item.payable_party_type.should == vendor.class.name
    end
  end

  context "billable party" do
    it "should be polymorphic 1" do
      line_item.billable_party = account;
      line_item.billable_party_id.should == account.id;
    end
    it "should be polymorphic 2" do
      line_item.billable_party = account;
      line_item.billable_party_type.should == account.class.name
    end
  end

  it "should be valid" do
    line_item.should be_valid
  end
end
