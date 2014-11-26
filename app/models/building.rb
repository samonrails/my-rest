# == Schema Information
#
# Table name: buildings
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  insurance_required     :boolean
#  insurance_requirements :string(1000)
#  parking_information    :string(1000)
#  loading_information    :string(1000)
#  site_directions        :string(1000)
#  market_id              :integer
#  address_id             :integer
#  contact_title          :string(255)
#  contact_name           :string(255)
#  contact_phone          :string(255)
#  contact_cell           :string(255)
#  contact_fax            :string(255)
#  contact_email          :string(255)
#  timezone               :string(255)
#  is_approved            :boolean          default(FALSE)
#

class Building < ApplicationModel
  include SearchSortPaginate
  include Fooda::Asset

  has_images

  belongs_to :market
  belongs_to :address
  accepts_nested_attributes_for :address, allow_destroy: true
  has_and_belongs_to_many :accounts
  has_many :locations, :dependent => :restrict
  has_many :vendor_insurances, :dependent => :destroy
  has_many :building_documents, :dependent => :destroy
  
  validates :name,     presence: true, uniqueness: true, if: :approved?
  validates :timezone, presence: true, if: :approved?
  validates :market,   presence: true, if: :approved?

  after_initialize :initial_values

  default_scope order('buildings.name ASC')

  def self.default_search_fields parent_model=nil
    [
      { :name => :name, :as => :string, :wildcard => :both },
    ]
  end

  def self.all_possible_search_fields parent_model=nil
    [
      { :name => :name, :as => :string, :wildcard => :both },
      { :name => :market, :as => :multi_select },
      { :name => :address, :as => :string, :wildcard => :both}
    ]
  end

  def default_image
    self.assets.where(:is_default => true).first
  end

  def html_address
    a = ""
    return a if address.nil?

    a << "#{address.address1}<br>" unless address.address1.empty? 
    a << "#{address.city}, " unless address.city.empty?
    a << "#{address.state} " unless address.state.empty?
    a << "#{address.zip_code}" unless address.zip_code.empty?

    a.html_safe
  end

  def address1
    (defined? self.address.address1) ? self.address.address1 : ""
  end

  def city
    (defined? self.address.city) ? self.address.city : ""
  end

  def state
    (defined? self.address.state) ? self.address.state : ""
  end

  def zip_code
    (defined? self.address.zip_code) ? self.address.zip_code : ""
  end

  def approve!
    update_attributes!(is_approved: true)
  end

    def pretty_id
    "#{self.id.to_s.rjust(7, "0")}"
  end

  private
    def initial_values
      self.insurance_requirements ||= ""
      self.parking_information ||= ""
      self.loading_information ||= ""
      self.site_directions ||= ""
    end

    def approved?
      self.is_approved
    end
end
