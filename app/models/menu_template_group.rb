# == Schema Information
#
# Table name: menu_template_groups
#
#  id                :integer          not null, primary key
#  menu_template_id  :integer
#  choices_to_select :integer
#  name              :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class MenuTemplateGroup < ApplicationModel
  belongs_to  :menu_template

  has_many :menu_template_inventory_items, :dependent => :restrict
  has_reputation :favorite, source: :user
  default_scope order 'name'
  
end
