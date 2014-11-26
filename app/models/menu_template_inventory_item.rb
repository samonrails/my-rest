# == Schema Information
#
# Table name: menu_template_inventory_items
#
#  id                     :integer          not null, primary key
#  inventory_item_id      :integer
#  menu_template_id       :integer
#  menu_template_group_id :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class MenuTemplateInventoryItem < ApplicationModel
  belongs_to :inventory_item
  belongs_to :menu_template
  belongs_to :menu_template_group
end
