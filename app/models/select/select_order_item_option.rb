# == Schema Information
#
# Table name: select_order_item_options
#
#  id                   :integer          not null, primary key
#  select_order_item_id :integer
#  inventory_item_id    :integer
#  quantity             :integer
#  special_instructions :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  unit_price_cents     :integer
#  option_group_id      :integer
#

class Select::SelectOrderItemOption < ActiveRecord::Base
  belongs_to :select_order_item
  belongs_to :inventory_item
  belongs_to :option_group

end
