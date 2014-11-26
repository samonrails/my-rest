# == Schema Information
#
# Table name: select_order_items
#
#  id                   :integer          not null, primary key
#  inventory_item_id    :integer
#  select_order_id      :integer
#  quantity             :integer
#  special_instructions :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  vendor_id            :integer
#  unit_price_cents     :integer          default(0), not null
#  status               :string(255)
#


class Select::SelectOrderItem < ActiveRecord::Base
  belongs_to :inventory_item
  belongs_to :select_order

  has_many :select_order_item_options, dependent: :destroy
  accepts_nested_attributes_for :select_order_item_options

  monetize :unit_price_cents

  before_save :apply_unit_price

  protected

    def apply_unit_price
      inventory_item = InventoryItem.find(self.inventory_item_id)
      self.unit_price_cents = SelectPricing.sum_sell_price_select_order_item(self).cents
    end

end
