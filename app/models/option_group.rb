# == Schema Information
#
# Table name: option_groups
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  included          :integer
#  max               :integer
#  inventory_item_id :integer
#  required          :integer
#

class OptionGroup < ApplicationModel

  has_and_belongs_to_many :inventory_items
  validates :name, presence: true
  after_initialize :initial_values
  default_scope order 'name'
  has_reputation :favorite, source: :user

  private

    def initial_values
      self.included ||= 0
      self.required ||= 0
    end

end