# == Schema Information
#
# Table name: inventory_item_product_types
#
#  id                :integer          not null, primary key
#  inventory_item_id :integer
#  product_type      :string(20)
#

class InventoryItemProductType < ApplicationModel
  belongs_to :inventory_item
end