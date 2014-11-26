# == Schema Information
#
# Table name: delivery_groups
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  location_ids :text
#  user_id      :integer
#

class DeliveryGroup < ApplicationModel
  serialize :location_ids
  belongs_to :user
  validates :name, :user_id, :location_ids, presence: true

  def displayable_locations
    locations.map{|l| "#{l.account.name} (#{l.name})"}.join("; ")
  end

  def locations
    # Not efficient, but this preserves order and saves upkeeping sort position in the DB
    @locations ||= location_ids.map{|id| Location.includes(:account).find(id)}
  end

  def as_json(options={})
    {id: id, locations: locations}
  end

end
