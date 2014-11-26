# == Schema Information
#
# Table name: inventory_items_option_groups
#
#  inventory_item_id :integer
#  option_group_id   :integer
#

class InventoryItemsOptionGroup < ApplicationModel
  belongs_to :inventory_item
  belongs_to :option_group
end