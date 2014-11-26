# == Schema Information
#
# Table name: ssp_persistences
#
#  id                   :integer          not null, primary key
#  ssp_persistence_type :string(255)
#  name                 :string(255)
#  parameters           :text
#  locked               :boolean          default(FALSE), not null
#

class SspPersistence < ApplicationModel
  validates :ssp_persistence_type, :name, :parameters, presence: true
end