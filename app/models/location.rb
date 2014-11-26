# == Schema Information
#
# Table name: locations
#
#  id                          :integer          not null, primary key
#  name                        :string(255)
#  location_type               :string(255)
#  expected_participation      :integer
#  privacy                     :string(255)
#  service_event_instructions  :text
#  connectivity_instructions   :text
#  delivery_event_instructions :text
#  building_address_notes      :string(255)
#  contact_id                  :integer
#  account_id                  :integer
#  building_id                 :integer
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  created_by_id               :integer
#  deleted_at                  :datetime
#  deleted_by_id               :integer
#  default_site_fee_cents      :integer
#

class Location < ApplicationModel
  include Fooda::Asset
  acts_as_paranoid

  has_images
  has_many :events, :dependent => :restrict

  belongs_to :account
  belongs_to :building
  belongs_to :contact
  belongs_to :created_by, :class_name => "User"
  belongs_to :deleted_by, :class_name => "User"
  has_many   :location_documents, :dependent => :destroy


  before_destroy :delete_default_account_location
  
  validates_presence_of :account_id
  validates_presence_of :building_id
  validates :name, presence: true
  validates :default_site_fee_cents, :numericality => true

  default_scope order 'name'

  after_initialize :initial_values

  monetize :default_site_fee_cents

  def spot?
    self.location_type == LocationType.spot
  end

  def delivery?
    self.location_type == LocationType.delivery
  end

  def html_address
    address = ""
    return address unless defined? building.address

    address << "#{building.address.address1}<br>" unless building.address.address1.empty? 
    address << "#{building_address_notes}<br>" unless building_address_notes.empty?
    address << "#{building.address.city}, " unless building.address.city.empty?
    address << "#{building.address.state} " unless building.address.state.empty?
    address << "#{building.address.zip_code}" unless building.address.zip_code.empty?

    address.html_safe
  end

  def pretty_id
    "#{self.id.to_s.rjust(7, "0")}"
  end

  def default_image
    self.assets.where(:is_default => true).first
  end

  def to_s
    self.name
  end

  def address1
    (defined? self.building.address.address1) ? self.building.address.address1 : ""
  end

  def address1= address1
    self.building.address.address1 = address1 if defined?(self.building.address) 
  end

  def address2
    defined?(self.building_address_notes) ? self.building_address_notes : ""
  end

  def address2= address2
    self.building_address_notes = address2
  end

  def city
    defined?(self.building.address.city) ? self.building.address.city : ""
  end

  def city= city
    self.building.address.city = city if defined?(self.building.address) 
  end

  def state
    defined?(self.building.address.state) ? self.building.address.state : ""
  end

  def state= state
    self.building.address.state = state if defined?(self.building.address) 
  end

  def zip_code
    defined?(self.building.address.zip_code) ? self.building.address.zip_code : ""
  end

  def zip_code= zip_code
    self.building.address.zip_code = zip_code if defined?(self.building.address) 
  end

  def delete_default_account_location
    users = User.find_all_by_default_account_location_id(self.id)
    users.each do |user|
         user.update_attributes(default_account_location_id: nil)
      end
  end

  private

    def initial_values
      self.expected_participation ||= 0
      self.service_event_instructions ||= ""
      self.connectivity_instructions ||= ""
      self.delivery_event_instructions ||= ""
      self.building_address_notes ||= ""
      self.location_type ||= "delivery"
      self.default_site_fee_cents ||= 0 
    end

end
