# == Schema Information
#
# Table name: menu_templates
#
#  id                           :integer          not null, primary key
#  name                         :string(255)
#  pricing_type                 :string(255)
#  expiration_date              :date
#  start_date                   :date             not null
#  vendor_id                    :integer
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  product_type                 :string(20)
#  cogs_cents                   :integer
#  sell_price_cents             :integer
#  retail_price_cents           :integer
#  expires                      :boolean
#  all_items                    :boolean          default(FALSE), not null
#  is_eligible_for_self_service :boolean          default(FALSE), not null
#  description                  :text
#  min_quantity                 :integer          default(0), not null
#  cuisine                      :string(255)
#  dietary_restrictions         :text
#  external_tags                :text
#  is_default                   :boolean          default(FALSE)
#

require "spec_helper"

describe MenuTemplate do
  let(:vendor) { create(:vendor) }

  let(:menu_template) do
    vendor          = create(:vendor)
    menu_template   = create(:menu_template, vendor: vendor)

    3.times do
      menu_template.inventory_items << create(:inventory_item, vendor: vendor)
    end

    3.times do
      menu_template.menu_level_discounts << create(:menu_level_discount)
    end

    menu_template
  end

  it "should restrict the template to valid product types" do
    template = MenuTemplate.new(:product_type=>"gun", :start_date => 5.days.from_now)
    template.should_not be_valid
  end

  it "should be valid " do
    menu_template.should be_valid
  end

  it "should have inventory items" do
    menu_template.inventory_items.should_not be_empty
  end

  it "should have menu level disounts" do
    menu_template.menu_level_discounts.should_not be_empty
  end
end
