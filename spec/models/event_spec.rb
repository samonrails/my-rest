# == Schema Information
#
# Table name: events
#
#  id                               :integer          not null, primary key
#  name                             :string(255)
#  meal_period                      :string(255)
#  account_id                       :integer
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  quantity                         :integer
#  product                          :string(30)
#  menu_name                        :string(255)
#  status                           :string(255)
#  contact_id                       :integer
#  service_style                    :string(255)
#  individual_label                 :boolean
#  utensils_plates_napkins          :boolean
#  serving_utensils                 :boolean
#  sternos                          :boolean
#  chaffing_frames                  :boolean
#  internal_event_notes             :text
#  external_account_notes           :text
#  building_instructions            :text
#  location_instructions            :text
#  location_id                      :integer
#  event_transaction_method_id      :integer
#  event_start_time                 :datetime
#  event_end_time                   :datetime
#  setup_start_time                 :datetime
#  setup_end_time                   :datetime
#  created_by_id                    :integer
#  event_start_time_utc             :datetime
#  event_end_time_utc               :datetime
#  setup_start_time_utc             :datetime
#  setup_end_time_utc               :datetime
#  event_managed_services_rollup_id :integer
#  cancellation_reason              :string(255)
#  canceled_within_24_hours         :boolean          default(FALSE), not null
#  event_schedule_id                :integer
#  event_owner_id                   :integer
#  feedback_status                  :string(255)
#  feedback_updated_at              :datetime
#  duplicated_from_event_id         :integer
#  claimed_at                       :datetime
#


require 'spec_helper'

describe Event do

  before(:each) do
    if PricingTier.all.count == 0
      Fooda::Util::create_pricing_tiers
    end

    if LineItemType.all.count == 0
      Fooda::Util::create_line_item_types
    end
  end

  # Vendor-side
  let(:vendor) { create(:vendor) }

  # Account-side
  let(:account) { create(:account) }

  # Event-side
  let(:product) { 'catering' }
  let(:populated_menu_template_catering) do
    menu_template   = create(:menu_template, vendor: vendor, pricing_type: MenuPricingType.menu_level, cogs: 7.10, retail_price: 9.40)

    # do some work to make sure that the inventory items all have unique buy prices
    3.times { |count|
      menu_template.inventory_items << create(:inventory_item, vendor: vendor, cogs: 10*count + 1)
    }

    # do some work to make sure that the menu level discounts all have unique buy and sell prices
    3.times { |count|
      menu_template.menu_level_discounts << create(:menu_level_discount, cogs: 10*count + 1, sell_price: 10*count + 2)
    }

    menu_template
  end

  let (:event_catering) do
    e1 = Event.create!(
      :account => account,
      :name => "My Catering Event", :event_start_time => "5/1/2013 11:30pm", 
      :meal_period => MealPeriod.lunch, :product => product, :location => FactoryGirl.create(:spot_location))

    e1.add_replace_menu_template(populated_menu_template_catering, 40)
    e1
  end

  let (:event_catering_account_credit) do
    e1 = Event.create!(
      :account => account,
      :name => "My Catering Event", :event_start_time => "5/1/2013 11:30pm", 
      :meal_period => MealPeriod.lunch, :product => product, :location => FactoryGirl.create(:spot_location))

    e1.add_replace_menu_template(populated_menu_template_catering, 40)

    line_item_type = LineItemType.where(:line_item_type => "Financial", :line_item_sub_type => "Credit Memo").first

    e1.line_items.create!(
      :line_item_type => line_item_type.line_item_type,
      :line_item_sub_type => line_item_type.line_item_sub_type,
      :sku => line_item_type.sku,
      :name => line_item_type.line_item_type,
      :notes => "Do some stuff",
      :quantity => 1,
      :include_price_in_expense => true,
      :include_price_in_revenue => true,
      :billable_party_type => "Account",
      :billable_party_id => e1.account.id,
      :unit_price_revenue => 45.15)

    e1
  end

  let (:event_catering_vendor_credit) do
    e1 = Event.create!(
      :account => account,
      :name => "My Catering Event", :event_start_time => "5/1/2013 11:30pm", 
      :meal_period => MealPeriod.lunch, :product => product, :location => FactoryGirl.create(:spot_location))

    e1.add_replace_menu_template(populated_menu_template_catering, 40)

    line_item_type = LineItemType.where(:line_item_type => "Financial", :line_item_sub_type => "Credit Memo").first

    e1.line_items.create!(
      :line_item_type => line_item_type.line_item_type,
      :line_item_sub_type => line_item_type.line_item_sub_type,
      :sku => line_item_type.sku,
      :name => line_item_type.line_item_type,
      :notes => "Do some stuff",
      :quantity => 1,
      :include_price_in_expense => true,
      :include_price_in_revenue => true,
      :payable_party_type => "Vendor",
      :payable_party_id => e1.event_vendors.first.vendor.id,
      :unit_price_expense => 45.15)

    e1
  end

  let (:event_catering_account_credit_after_subtotal) do
    e1 = Event.create!(
      :account => account,
      :name => "My Catering Event", :event_start_time => "5/1/2013 11:30pm", 
      :meal_period => MealPeriod.lunch, :product => product, :location => FactoryGirl.create(:spot_location))

    e1.add_replace_menu_template(populated_menu_template_catering, 40)

    line_item_type = LineItemType.where(:line_item_type => "Financial", :line_item_sub_type => "Credit Memo").first

    e1.line_items.create!(
      :line_item_type => line_item_type.line_item_type,
      :line_item_sub_type => line_item_type.line_item_sub_type,
      :sku => line_item_type.sku,
      :name => line_item_type.line_item_type,
      :notes => "Do some stuff",
      :quantity => 1,
      :include_price_in_expense => true,
      :include_price_in_revenue => true,
      :billable_party_type => "Account",
      :billable_party_id => e1.account.id,
      :unit_price_revenue => 45.15,
      :after_subtotal => true)

    e1
  end

  let (:event_catering_vendor_credit_after_subtotal) do
    e1 = Event.create!(
      :account => account,
      :name => "My Catering Event", :event_start_time => "5/1/2013 11:30pm", 
      :meal_period => MealPeriod.lunch, :product => product, :location => FactoryGirl.create(:spot_location))

    e1.add_replace_menu_template(populated_menu_template_catering, 40)

    line_item_type = LineItemType.where(:line_item_type => "Financial", :line_item_sub_type => "Credit Memo").first

    e1.line_items.create!(
      :line_item_type => line_item_type.line_item_type,
      :line_item_sub_type => line_item_type.line_item_sub_type,
      :sku => line_item_type.sku,
      :name => line_item_type.line_item_type,
      :notes => "Do some stuff",
      :quantity => 1,
      :include_price_in_expense => true,
      :include_price_in_revenue => true,
      :payable_party_type => "Vendor",
      :payable_party_id => e1.event_vendors.first.vendor.id,
      :unit_price_expense => 45.15,
      :after_subtotal => true)

    e1
  end

  let (:event_catering_account_credit_after_subtotal_percentage) do
    e1 = Event.create!(
      :account => account,
      :name => "My Catering Event", :event_start_time => "5/1/2013 11:30pm", 
      :meal_period => MealPeriod.lunch, :product => product, :location => FactoryGirl.create(:spot_location))

    e1.add_replace_menu_template(populated_menu_template_catering, 40)

    line_item_type = LineItemType.where(:line_item_type => "Financial", :line_item_sub_type => "Credit Memo").first

    e1.line_items.create!(
      :line_item_type => line_item_type.line_item_type,
      :line_item_sub_type => line_item_type.line_item_sub_type,
      :sku => line_item_type.sku,
      :name => line_item_type.line_item_type,
      :notes => "Do some stuff",
      :quantity => 1,
      :include_price_in_expense => true,
      :include_price_in_revenue => true,
      :billable_party_type => "Account",
      :billable_party_id => e1.account.id,
      :unit_price_revenue => 45.15,
      :after_subtotal => true,
      :percentage_of_subtotal => true)

    e1
  end

  let (:event_catering_vendor_credit_after_subtotal_percentage) do
    e1 = Event.create!(
      :account => account,
      :name => "My Catering Event", :event_start_time => "5/1/2013 11:30pm", 
      :meal_period => MealPeriod.lunch, :product => product, :location => FactoryGirl.create(:spot_location))

    e1.add_replace_menu_template(populated_menu_template_catering, 40)

    line_item_type = LineItemType.where(:line_item_type => "Financial", :line_item_sub_type => "Credit Memo").first

    e1.line_items.create!(
      :line_item_type => line_item_type.line_item_type,
      :line_item_sub_type => line_item_type.line_item_sub_type,
      :sku => line_item_type.sku,
      :name => line_item_type.line_item_type,
      :notes => "Do some stuff",
      :quantity => 1,
      :include_price_in_expense => true,
      :include_price_in_revenue => true,
      :payable_party_type => "Vendor",
      :payable_party_id => e1.event_vendors.first.vendor.id,
      :unit_price_expense => 45.15,
      :after_subtotal => true,
      :percentage_of_subtotal => true)

    e1
  end

  context "Setup" do
    it "should have a valid model state due to association existance" do
      event_catering.should be_valid
    end
  end

  context "when duplicating an event" do
    it "should create a new event"  do 
      pending "duplicate events tests"
    end

    it "should not duplicate an Event Vendors vendor_billing_summary_sent_at" do 
      pending "duplicate events tests"
    end
  end

  context "when in creation process" do

    it "should not save when an event is empty" do
      Event.new.save.should == false
    end

    it "should not save when there is no date set" do
      event_catering.event_start_time = nil
      event_catering.save.should == false
    end

    it "should not save if the account_id is not present" do
      event_catering.account_id = nil
      event_catering.save.should == false
    end

    it "should save when an event is not empty" do
      event_catering.save.should == true
    end

    it "should copy the cogs from the template"  do
      event_catering.event_vendors.first.default_menu_cogs.should == populated_menu_template_catering.cogs
    end
    it "should copy the retail price from the template"  do
      event_catering.event_vendors.first.default_menu_retail_price.should == populated_menu_template_catering.retail_price
    end
    it "should calculate the sell_price from the buy_price and the proper pricing tier"  do
      event_catering.event_vendors.first.default_menu_sell_price.should == Money.parse(populated_menu_template_catering.cogs / (1 - PricingTier.find_by_account_and_product(event_catering.account, event_catering.product).gross_profit / 100))
    end
    it "should copy the pricing_type from the template"  do
      event_catering.event_vendors.first.pricing_type.should == populated_menu_template_catering.pricing_type
    end

    it "should create the correct number of account Menu-Item line items 1"  do
      event_catering.line_items.select{|li| li.billable_party == event_catering.account && li.line_item_sub_type == "Menu-Item"}.count.should == populated_menu_template_catering.inventory_items.count
    end

    it "should create the correct number of account Menu-Item line items 2"  do
      event_catering.line_items.select{|li| li.payable_party == event_catering.account && li.line_item_sub_type == "Menu-Item"}.count.should == 0
    end

    it "should create the correct number of vendor Menu-Item line items 1"  do
      event_catering.line_items.select{|li| li.payable_party == event_catering.event_vendors.first.vendor && li.line_item_sub_type == "Menu-Item"}.count.should == populated_menu_template_catering.inventory_items.count
    end

    it "should create the correct number of vendor Menu-Item line items 2"  do
      event_catering.line_items.select{|li| li.billable_party == event_catering.event_vendors.first.vendor && li.line_item_sub_type == "Menu-Item"}.count.should == 0
    end

    it "should create the correct number of account Menu-Fee line items 1"  do
      event_catering.line_items.select{|li| li.billable_party == event_catering.account && li.line_item_sub_type == "Menu-Fee"}.count.should == 1
    end

    it "should create the correct number of account Menu-Fee line items 2"  do
      event_catering.line_items.select{|li| li.payable_party == event_catering.account && li.line_item_sub_type == "Menu-Fee"}.count.should == 0
    end

    it "should create the correct number of vendor Menu-Fee line items 1"  do
      event_catering.line_items.select{|li| li.payable_party == event_catering.event_vendors.first.vendor && li.line_item_sub_type == "Menu-Fee"}.count.should == 1
    end

    it "should create the correct number of vendor Menu-Fee line items 2"  do
      event_catering.line_items.select{|li| li.billable_party == event_catering.event_vendors.first.vendor && li.line_item_sub_type == "Menu-Fee"}.count.should == 0
    end

      3.times { |count|
      it "should have the correct cogs value in all inventory items " + count.to_s do
        event_catering.line_items.select{|li| li.payable_party == event_catering.event_vendors.first.vendor && li.line_item_sub_type == "Menu-Item"}.sort_by{|li| li.id}[count].unit_price_expense.should == populated_menu_template_catering.inventory_items[count].cogs
      end
    }

    3.times { |count|
      it "should apply the correct price multiplier to inventory item COGS " + count.to_s do
        if Product.find_parent(product) == "perks"
          event_catering.line_items.select{|li| li.billable_party == event_catering.account && li.line_item_sub_type == "Menu-Item"}.sort_by{|li| li.id}[count].unit_price_revenue.should == populated_menu_template_catering.inventory_items[count].perks_price
        else
          event_catering.line_items.select{|li| li.billable_party == event_catering.account && li.line_item_sub_type == "Menu-Item"}.sort_by{|li| li.id}[count].unit_price_revenue.should == Money.parse(populated_menu_template_catering.inventory_items[count].cogs / (1 - PricingTier.find_by_account_and_product(event_catering.account, event_catering.product).gross_profit / 100))
        end
      end
    }

    it "should copy the correct number of menu level discounts"  do
      event_catering.event_vendors.first.menu_level_discounts.count.should == populated_menu_template_catering.menu_level_discounts.count
    end

    3.times { |count|
      it "should copy the menu_level_discount buy_price to menu_level_discount number " + count.to_s do
        event_catering.event_vendors.first.menu_level_discounts[count].cogs.should == populated_menu_template_catering.menu_level_discounts[count].cogs
      end
    }

    3.times { |count|
      it "should calculate the menu_level_discount sell_price from the menu_level_discount buy_price and the proper pricing tier " + count.to_s do
        event_catering.event_vendors.first.menu_level_discounts[count].sell_price.should == Money.parse(populated_menu_template_catering.menu_level_discounts[count].cogs / (1 - PricingTier.find_by_account_and_product(event_catering.account, event_catering.product).gross_profit / 100))
      end
    }

  end

  context "rolling up catering prices with just a per-person fee" do

    it "calculate the revenue sub-total"  do
      event_catering.revenue_subtotal_by_party(account).should == event_catering.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Menu-Fee"}.first.revenue_total
    end

    it "calculate the revenue tax"  do
      event_catering.revenue_general_tax_by_party(account).should == event_catering.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Menu-Fee"}.first.revenue_tax
    end

    it "calculate the revenue after-subtotal items"  do
      event_catering.revenue_after_subtotal_by_party(account).should == 0
    end

    it "calculate the revenue total"  do
      event_catering.revenue_total_by_party(account).should == 
        event_catering.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Menu-Fee"}.first.revenue_total +
        event_catering.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Menu-Fee"}.first.revenue_tax
    end

    it "calculate the expense sub-total"  do
      event_catering.expense_subtotal_by_party(vendor).should == event_catering.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Menu-Fee"}.first.expense_total
    end

    it "calculate the expense tax"  do
      event_catering.expense_general_tax_by_party(vendor).should == event_catering.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Menu-Fee"}.first.expense_tax
    end

    it "calculate the expense after-subtotal items"  do
      event_catering.expense_after_subtotal_by_party(vendor).should == 0
    end

    it "calculate the expense total"  do
      event_catering.expense_total_by_party(vendor).should == 
        event_catering.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Menu-Fee"}.first.expense_total +
        event_catering.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Menu-Fee"}.first.expense_tax
    end

    it "calculate the total of Menu-Fee revenue items" do
      event_catering.revenue_by_party_and_line_item_subtype(account, "Menu-Fee") == 
      event_catering.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Menu-Fee"}.first.revenue_total
    end

    it "calculate the total of Menu-Fee expense items" do
      event_catering.expense_by_party_and_line_item_subtype(vendor, "Menu-Fee") == 
      event_catering.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Menu-Fee"}.first.expense_total
    end

  end

  context "rolling up catering prices with a per-person fee and subtotal-included account credit" do

    it "calculate the revenue sub-total"  do

      event_catering_account_credit.revenue_subtotal_by_party(account).should == 
        event_catering_account_credit.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Menu-Fee"}.first.revenue_total +
        event_catering_account_credit.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Credit Memo"}.first.revenue_total
    end

    it "calculate the revenue tax"  do
      event_catering_account_credit.revenue_general_tax_by_party(account).should == 
        event_catering_account_credit.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Menu-Fee"}.first.revenue_tax +
        event_catering_account_credit.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Credit Memo"}.first.revenue_tax
    end

    it "calculate the revenue after-subtotal items"  do
      event_catering_account_credit.revenue_after_subtotal_by_party(account).should == 0
    end

    it "calculate the revenue total"  do
      event_catering_account_credit.revenue_total_by_party(account).should == 
        event_catering_account_credit.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Menu-Fee"}.first.revenue_total +
        event_catering_account_credit.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Menu-Fee"}.first.revenue_tax +
        event_catering_account_credit.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Credit Memo"}.first.revenue_total +
        event_catering_account_credit.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Credit Memo"}.first.revenue_tax
    end

    it "calculate the expense sub-total"  do
      event_catering_account_credit.expense_subtotal_by_party(vendor).should == 
        event_catering_account_credit.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Menu-Fee"}.first.expense_total
    end

    it "calculate the expense tax"  do
      event_catering_account_credit.expense_general_tax_by_party(vendor).should == 
        event_catering_account_credit.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Menu-Fee"}.first.expense_tax
    end

    it "calculate the expense after-subtotal items"  do
      event_catering_account_credit.expense_after_subtotal_by_party(vendor).should == 0
    end

    it "calculate the expense total"  do
      event_catering_account_credit.expense_total_by_party(vendor).should == 
        event_catering_account_credit.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Menu-Fee"}.first.expense_total +
        event_catering_account_credit.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Menu-Fee"}.first.expense_tax
    end

    it "calculate the total of Menu-Fee revenue items" do
      event_catering_account_credit.revenue_by_party_and_line_item_subtype(account, "Menu-Fee") == 
        event_catering_account_credit.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Menu-Fee"}.first.revenue_total
    end

    it "calculate the total of Menu-Fee expense items" do
      event_catering_account_credit.revenue_by_party_and_line_item_subtype(vendor, "Menu-Fee") == 
        event_catering_account_credit.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Menu-Fee"}.first.expense_total
    end

    it "calculate the total of Credit Memo revenue items" do
      event_catering_account_credit.revenue_by_party_and_line_item_subtype(account, "Credit Memo") == 
        event_catering_account_credit.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Credit Memo"}.first.revenue_total
    end

    it "calculate the total of Credit Memo expense items" do
      event_catering_account_credit.revenue_by_party_and_line_item_subtype(vendor, "Credit Memo") == 0
    end

  end

  context "rolling up catering prices with a per-person fee and subtotal-included vendor credit" do

    it "calculate the revenue sub-total"  do
      event_catering_vendor_credit.revenue_subtotal_by_party(account).should == 
        event_catering_vendor_credit.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Menu-Fee"}.first.revenue_total
    end

    it "calculate the revenue tax"  do
      event_catering_vendor_credit.revenue_general_tax_by_party(account).should == 
        event_catering_vendor_credit.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Menu-Fee"}.first.revenue_tax
    end

    it "calculate the revenue after-subtotal items"  do
      event_catering_vendor_credit.revenue_after_subtotal_by_party(account).should == 0
    end

    it "calculate the revenue total"  do
      event_catering_vendor_credit.revenue_total_by_party(account).should == 
        event_catering_vendor_credit.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Menu-Fee"}.first.revenue_total +
        event_catering_vendor_credit.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Menu-Fee"}.first.revenue_tax
    end

    it "calculate the expense sub-total"  do
      event_catering_vendor_credit.expense_subtotal_by_party(vendor).should == 
        event_catering_vendor_credit.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Menu-Fee"}.first.expense_total +
        event_catering_vendor_credit.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Credit Memo"}.first.expense_total
    end

    it "calculate the expense tax"  do
      event_catering_vendor_credit.expense_general_tax_by_party(vendor).should == 
        event_catering_vendor_credit.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Menu-Fee"}.first.expense_tax +
        event_catering_vendor_credit.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Credit Memo"}.first.expense_tax
    end

    it "calculate the expense after-subtotal items"  do
      event_catering_vendor_credit.expense_after_subtotal_by_party(vendor).should == 0
    end

    it "calculate the expense total"  do
      event_catering_vendor_credit.expense_total_by_party(vendor).should == 
        event_catering_vendor_credit.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Menu-Fee"}.first.expense_total +
        event_catering_vendor_credit.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Menu-Fee"}.first.expense_tax +
        event_catering_vendor_credit.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Credit Memo"}.first.expense_total +
        event_catering_vendor_credit.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Credit Memo"}.first.expense_tax
    end

    it "calculate the total of Menu-Fee revenue items" do
      event_catering_vendor_credit.revenue_by_party_and_line_item_subtype(account, "Menu-Fee") == 
        event_catering_vendor_credit.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Menu-Fee"}.first.revenue_total
    end

    it "calculate the total of Menu-Fee expense items" do
      event_catering_vendor_credit.revenue_by_party_and_line_item_subtype(vendor, "Menu-Fee") == 
        event_catering_vendor_credit.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Menu-Fee"}.first.expense_total
    end

    it "calculate the total of Credit Memo revenue items" do
      event_catering_vendor_credit.revenue_by_party_and_line_item_subtype(account, "Credit Memo") == 0
    end

    it "calculate the total of Credit Memo expense items" do
      event_catering_vendor_credit.revenue_by_party_and_line_item_subtype(vendor, "Credit Memo") ==
        event_catering_vendor_credit.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Credit Memo"}.first.expense_total
    end

  end

  context "rolling up catering prices with a per-person fee and and after-subtotal account credit" do

    it "calculate the revenue sub-total"  do
      event_catering_account_credit_after_subtotal.revenue_subtotal_by_party(account).should == 
        event_catering_account_credit_after_subtotal.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Menu-Fee"}.first.revenue_total
    end

    it "calculate the revenue tax"  do
      event_catering_account_credit_after_subtotal.revenue_general_tax_by_party(account).should == 
        event_catering_account_credit_after_subtotal.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Menu-Fee"}.first.revenue_tax
    end

    it "calculate the revenue after-subtotal items"  do
      event_catering_account_credit_after_subtotal.revenue_after_subtotal_by_party(account).should ==
        event_catering_account_credit_after_subtotal.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Credit Memo"}.first.revenue_total
    end

    it "calculate the revenue total"  do
      event_catering_account_credit_after_subtotal.revenue_total_by_party(account).should == 
        event_catering_account_credit_after_subtotal.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Menu-Fee"}.first.revenue_total +
        event_catering_account_credit_after_subtotal.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Menu-Fee"}.first.revenue_tax +
        event_catering_account_credit_after_subtotal.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Credit Memo"}.first.revenue_total
    end

    it "calculate the expense sub-total"  do
      event_catering_account_credit_after_subtotal.expense_subtotal_by_party(vendor).should == 
        event_catering_account_credit_after_subtotal.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Menu-Fee"}.first.expense_total
    end

    it "calculate the expense tax"  do
      event_catering_account_credit_after_subtotal.expense_general_tax_by_party(vendor).should == 
        event_catering_account_credit_after_subtotal.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Menu-Fee"}.first.expense_tax
    end

    it "calculate the expense after-subtotal items"  do
      event_catering_account_credit_after_subtotal.expense_after_subtotal_by_party(vendor).should == 0
    end

    it "calculate the expense total"  do
      event_catering_account_credit_after_subtotal.expense_total_by_party(vendor).should == 
        event_catering_account_credit_after_subtotal.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Menu-Fee"}.first.expense_total +
        event_catering_account_credit_after_subtotal.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Menu-Fee"}.first.expense_tax
    end

    it "calculate the total of Menu-Fee revenue items" do
      event_catering_account_credit.revenue_by_party_and_line_item_subtype(account, "Menu-Fee") == 
        event_catering_account_credit.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Menu-Fee"}.first.revenue_total
    end

    it "calculate the total of Menu-Fee expense items" do
      event_catering_account_credit.revenue_by_party_and_line_item_subtype(vendor, "Menu-Fee") == 
        event_catering_account_credit.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Menu-Fee"}.first.expense_total
    end

    it "calculate the total of Credit Memo revenue items" do
      event_catering_account_credit.revenue_by_party_and_line_item_subtype(account, "Credit Memo") == 
        event_catering_account_credit.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Credit Memo"}.first.revenue_total
    end

    it "calculate the total of Credit Memo expense items" do
      event_catering_account_credit.revenue_by_party_and_line_item_subtype(vendor, "Credit Memo") == 0
    end

  end

  context "rolling up catering prices with a per-person fee and an after-subtotal vendor credit" do

    it "calculate the revenue sub-total"  do
      event_catering_vendor_credit_after_subtotal.revenue_subtotal_by_party(account).should == 
        event_catering_vendor_credit_after_subtotal.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Menu-Fee"}.first.revenue_total
    end

    it "calculate the revenue tax"  do
      event_catering_vendor_credit_after_subtotal.revenue_general_tax_by_party(account).should == 
        event_catering_vendor_credit_after_subtotal.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Menu-Fee"}.first.revenue_tax
    end

    it "calculate the revenue after-subtotal items"  do
      event_catering_vendor_credit_after_subtotal.revenue_after_subtotal_by_party(account).should == 0
    end

    it "calculate the revenue total"  do
      event_catering_vendor_credit_after_subtotal.revenue_total_by_party(account).should == 
        event_catering_vendor_credit_after_subtotal.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Menu-Fee"}.first.revenue_total +
        event_catering_vendor_credit_after_subtotal.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Menu-Fee"}.first.revenue_tax
    end

    it "calculate the expense sub-total"  do
      event_catering_vendor_credit_after_subtotal.expense_subtotal_by_party(vendor).should == 
        event_catering_vendor_credit_after_subtotal.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Menu-Fee"}.first.expense_total
    end

    it "calculate the expense tax"  do
      event_catering_vendor_credit_after_subtotal.expense_general_tax_by_party(vendor).should == 
        event_catering_vendor_credit_after_subtotal.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Menu-Fee"}.first.expense_tax
    end

    it "calculate the expense after-subtotal items"  do
      event_catering_vendor_credit_after_subtotal.expense_after_subtotal_by_party(vendor).should ==
        event_catering_vendor_credit_after_subtotal.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Credit Memo"}.first.expense_total
    end

    it "calculate the expense total"  do
      event_catering_vendor_credit_after_subtotal.expense_total_by_party(vendor).should == 
        event_catering_vendor_credit_after_subtotal.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Menu-Fee"}.first.expense_total +
        event_catering_vendor_credit_after_subtotal.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Menu-Fee"}.first.expense_tax +
        event_catering_vendor_credit_after_subtotal.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Credit Memo"}.first.expense_total
    end

    it "calculate the total of Menu-Fee revenue items" do
      event_catering_vendor_credit.revenue_by_party_and_line_item_subtype(account, "Menu-Fee") == 
        event_catering_vendor_credit.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Menu-Fee"}.first.revenue_total
    end

    it "calculate the total of Menu-Fee expense items" do
      event_catering_vendor_credit.revenue_by_party_and_line_item_subtype(vendor, "Menu-Fee") == 
        event_catering_vendor_credit.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Menu-Fee"}.first.expense_total
    end

    it "calculate the total of Credit Memo revenue items" do
      event_catering_vendor_credit.revenue_by_party_and_line_item_subtype(account, "Credit Memo") == 0
    end

    it "calculate the total of Credit Memo expense items" do
      event_catering_vendor_credit.revenue_by_party_and_line_item_subtype(vendor, "Credit Memo") ==
        event_catering_vendor_credit.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Credit Memo"}.first.expense_total
    end

  end

  context "rolling up catering prices with a per-person fee and and after-subtotal account credit that is a percentage" do

    it "calculate the revenue sub-total"  do
      event_catering_account_credit_after_subtotal_percentage.revenue_subtotal_by_party(account).should == 
        event_catering_account_credit_after_subtotal_percentage.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Menu-Fee"}.first.revenue_total
    end

    it "calculate the revenue tax"  do
      event_catering_account_credit_after_subtotal_percentage.revenue_general_tax_by_party(account).should == 
        event_catering_account_credit_after_subtotal_percentage.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Menu-Fee"}.first.revenue_tax
    end

    it "calculate the revenue after-subtotal items"  do
      event_catering_account_credit_after_subtotal_percentage.revenue_after_subtotal_by_party(account).should ==
        event_catering_account_credit_after_subtotal_percentage.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Credit Memo"}.first.revenue_total_with_percentage(
          event_catering_account_credit_after_subtotal_percentage.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Menu-Fee"}.first.revenue_total)
    end

    it "calculate the revenue total"  do
      event_catering_account_credit_after_subtotal_percentage.revenue_total_by_party(account).should == 
        event_catering_account_credit_after_subtotal_percentage.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Menu-Fee"}.first.revenue_total +
        event_catering_account_credit_after_subtotal_percentage.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Menu-Fee"}.first.revenue_tax +
        event_catering_account_credit_after_subtotal_percentage.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Credit Memo"}.first.revenue_total_with_percentage(
          event_catering_account_credit_after_subtotal_percentage.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Menu-Fee"}.first.revenue_total)
    end

    it "calculate the expense sub-total"  do
      event_catering_account_credit_after_subtotal_percentage.expense_subtotal_by_party(vendor).should == 
        event_catering_account_credit_after_subtotal_percentage.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Menu-Fee"}.first.expense_total
    end

    it "calculate the expense tax"  do
      event_catering_account_credit_after_subtotal_percentage.expense_general_tax_by_party(vendor).should == 
        event_catering_account_credit_after_subtotal_percentage.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Menu-Fee"}.first.expense_tax
    end

    it "calculate the expense after-subtotal items"  do
      event_catering_account_credit_after_subtotal_percentage.expense_after_subtotal_by_party(vendor).should == 0
    end

    it "calculate the expense total"  do
      event_catering_account_credit_after_subtotal_percentage.expense_total_by_party(vendor).should == 
        event_catering_account_credit_after_subtotal_percentage.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Menu-Fee"}.first.expense_total +
        event_catering_account_credit_after_subtotal_percentage.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Menu-Fee"}.first.expense_tax
    end

    it "calculate the total of Menu-Fee revenue items" do
      event_catering_account_credit.revenue_by_party_and_line_item_subtype(account, "Menu-Fee") == 
        event_catering_account_credit.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Menu-Fee"}.first.revenue_total
    end

    it "calculate the total of Menu-Fee expense items" do
      event_catering_account_credit.revenue_by_party_and_line_item_subtype(vendor, "Menu-Fee") == 
        event_catering_account_credit.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Menu-Fee"}.first.expense_total
    end

    it "calculate the total of Credit Memo revenue items" do
      event_catering_account_credit.revenue_by_party_and_line_item_subtype(account, "Credit Memo") == 
        event_catering_account_credit_after_subtotal_percentage.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Credit Memo"}.first.revenue_total_with_percentage(
        event_catering_account_credit_after_subtotal_percentage.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Menu-Fee"}.first.revenue_total)
    end

    it "calculate the total of Credit Memo expense items" do
      event_catering_account_credit.revenue_by_party_and_line_item_subtype(vendor, "Credit Memo") == 0
    end

  end

  context "rolling up catering prices with a per-person fee and an after-subtotal vendor credit that is a percentage" do

    it "calculate the revenue sub-total"  do
      event_catering_vendor_credit_after_subtotal_percentage.revenue_subtotal_by_party(account).should == 
        event_catering_vendor_credit_after_subtotal_percentage.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Menu-Fee"}.first.revenue_total
    end

    it "calculate the revenue tax"  do
      event_catering_vendor_credit_after_subtotal_percentage.revenue_general_tax_by_party(account).should == 
        event_catering_vendor_credit_after_subtotal_percentage.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Menu-Fee"}.first.revenue_tax
    end

    it "calculate the revenue after-subtotal items"  do
      event_catering_vendor_credit_after_subtotal_percentage.revenue_after_subtotal_by_party(account).should == 0
    end

    it "calculate the revenue total"  do
      event_catering_vendor_credit_after_subtotal_percentage.revenue_total_by_party(account).should == 
        event_catering_vendor_credit_after_subtotal_percentage.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Menu-Fee"}.first.revenue_total +
        event_catering_vendor_credit_after_subtotal_percentage.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Menu-Fee"}.first.revenue_tax
    end

    it "calculate the expense sub-total"  do
      event_catering_vendor_credit_after_subtotal_percentage.expense_subtotal_by_party(vendor).should == 
        event_catering_vendor_credit_after_subtotal_percentage.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Menu-Fee"}.first.expense_total
    end

    it "calculate the expense tax"  do
      event_catering_vendor_credit_after_subtotal_percentage.expense_general_tax_by_party(vendor).should == 
        event_catering_vendor_credit_after_subtotal_percentage.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Menu-Fee"}.first.expense_tax
    end

    it "calculate the expense after-subtotal items"  do
      event_catering_vendor_credit_after_subtotal_percentage.expense_after_subtotal_by_party(vendor).should ==
        event_catering_vendor_credit_after_subtotal_percentage.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Credit Memo"}.first.expense_total_with_percentage(
          event_catering_vendor_credit_after_subtotal_percentage.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Menu-Fee"}.first.expense_total)
    end

    it "calculate the expense total"  do
      event_catering_vendor_credit_after_subtotal_percentage.expense_total_by_party(vendor).should == 
        event_catering_vendor_credit_after_subtotal_percentage.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Menu-Fee"}.first.expense_total +
        event_catering_vendor_credit_after_subtotal_percentage.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Menu-Fee"}.first.expense_tax +
        event_catering_vendor_credit_after_subtotal_percentage.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Credit Memo"}.first.expense_total_with_percentage(
          event_catering_vendor_credit_after_subtotal_percentage.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Menu-Fee"}.first.expense_total)
    end

    it "calculate the total of Menu-Fee revenue items" do
      event_catering_vendor_credit_after_subtotal_percentage.revenue_by_party_and_line_item_subtype(account, "Menu-Fee") == 
        event_catering_vendor_credit_after_subtotal_percentage.line_items.select{|li| li.billable_party == account && li.line_item_sub_type == "Menu-Fee"}.first.revenue_total
    end

    it "calculate the total of Menu-Fee expense items" do
      event_catering_vendor_credit_after_subtotal_percentage.revenue_by_party_and_line_item_subtype(vendor, "Menu-Fee") == 
        event_catering_vendor_credit_after_subtotal_percentage.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Menu-Fee"}.first.expense_total
    end

    it "calculate the total of Credit Memo revenue items" do
      event_catering_vendor_credit_after_subtotal_percentage.revenue_by_party_and_line_item_subtype(account, "Credit Memo") == 0
    end

    it "calculate the total of Credit Memo expense items" do
      event_catering_vendor_credit_after_subtotal_percentage.revenue_by_party_and_line_item_subtype(vendor, "Credit Memo") == 
        event_catering_vendor_credit_after_subtotal_percentage.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Credit Memo"}.first.expense_total_with_percentage(
        event_catering_vendor_credit_after_subtotal_percentage.line_items.select{|li| li.payable_party == vendor && li.line_item_sub_type == "Menu-Fee"}.first.expense_total)
    end

  end

  describe 'scope' do

    Fooda::Util::create_pricing_tiers
    3.times {FactoryGirl.create(:event)}
    3.times {FactoryGirl.create(:event_with_owner)}

    it "'unclaimed events' should fetch all events which are not claimed yet" do
      uc_events_query = Event.all.select{|e| e.event_owner_id == nil && %w{auto_generated proposed scheduled active in_progress}.include?(e.status)}.count
      uc_events_scope = Event.unclaimed_events.count
      uc_events_scope.should eq uc_events_query
    end
    
    it "'opened' should fetch all events with status - 'proposed, scheduled, active, in_progress'" do
      uc_events_query = Event.find(:all, :conditions => ['status in (?)', %w{proposed scheduled active in_progress}]).count
      uc_events_scope = Event.opened.count
      uc_events_scope.should eq uc_events_query
    end
    
    it "'completed' should fetch all events with status - 'complete, final'" do
      uc_events_query = Event.find(:all, :conditions => ['status in (?)', %w{complete final}]).count
      uc_events_scope = Event.completed.count
      uc_events_scope.should eq uc_events_query
    end
    
    it "'canceled' should fetch all events with status - 'canceled'" do
      uc_events_query = Event.find(:all, :conditions => ['status in (?)', %w{canceled}]).count
      uc_events_scope = Event.canceled.count
      uc_events_scope.should eq uc_events_query
    end
  end

  context "duplicating event" do
    let(:user) { create(:user) }
    let(:line_item) { create(:line_item) }
   
    it "should duplicate event with default market tax rate" do
      current_user = user
      li = line_item
      li.update_attribute("tax_rate_revenue" , 5.25)
      ev1 = li.event
      ev2 = ev1.duplicate current_user.id,{:event_start_time=> Date.tomorrow, :quantity=> rand(50..100), :meal_period=>["Breakfast", "Lunch"].sample, :name=>"test", :event_owner_id=>current_user.id, :id=>ev1.id}
      (li.revenue_tax_rate.to_f*100).should eq 5.25
      (ev2.line_items.first.revenue_tax_rate.to_f*100).should_not eq 5.25
      ev2.line_items.first.revenue_tax_rate.should eq ev2.line_items.first.default_tax_rate/100
    end
  end

end
