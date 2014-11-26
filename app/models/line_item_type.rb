# == Schema Information
#
# Table name: line_item_types
#
#  id                 :integer          not null, primary key
#  line_item_type     :string(255)
#  line_item_sub_type :string(255)
#  sku                :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class LineItemType < ApplicationModel

  validates_presence_of :line_item_type
  validates_presence_of :line_item_sub_type

  validates_uniqueness_of :line_item_type, :scope => :line_item_sub_type

  def to_s
    "#{ line_item_sub_type  }"
  end

  def self.non_menu_item_types
    LineItemType.where(["line_item_sub_type <> 'Menu-Item'"]).map{|item| [item.line_item_sub_type, item.line_item_type, item.id]}.group_by{|item| item[1]}
  end

  def self.non_menu_types
    LineItemType.where(["line_item_sub_type <> 'Menu-Item' AND line_item_sub_type <> 'Menu-Fee'"]).map{|item| [item.line_item_sub_type, item.line_item_type, item.id]}.group_by{|item| item[1]}
  end

end