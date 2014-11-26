# == Schema Information
#
# Table name: markets
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  default_tax_rate     :decimal(, )      default(10.5), not null
#  office_default_phone :string(255)
#  office_default_fax   :string(255)
#  office_default_email :string(255)
#  address1             :string(255)
#  address2             :string(255)
#  city                 :string(255)
#  state                :string(255)
#  office_default_sms   :string(255)
#

class Market < ApplicationModel
  validates :name, :presence => true
  has_many :buildings, :dependent => :restrict
  has_and_belongs_to_many :zip_codes

  default_scope order('name ASC')

  validates_uniqueness_of :name

  after_initialize :initial_values

  # Memcache Integration
  after_create  :inc_cache_counter
  after_update  :inc_cache_counter
  after_destroy :inc_cache_counter

  def initial_values
    self.address1 ||= ""
    self.address2 ||= ""
    self.city ||= ""
    self.state ||= ""

    self.office_default_phone ||= ""
    self.office_default_fax ||= ""
    self.office_default_email ||= ""
  end

  def html_address
    result = ""

    result << "#{address1}<br>" unless address1.empty? 
    result << "#{address2}<br>" unless address2.empty? 
    result << "#{city}, " unless city.empty?
    result << "#{state} " unless state.empty?

    result.html_safe
  end

  def find_or_update_zip_codes zip_codes_params
    zipcodes = []
    zip_codes_params.split("\r\n").each do |zipcode|
      zipcodes << ZipCode.find_or_create_by_zipcode(zipcode)
    end
    self.zip_codes = zipcodes
  end

  def list_zip_codes
    zip_codes.map(&:zipcode).join("\r\n")
  end

  def humanized_zip_codes
    zip_codes.map(&:zipcode).join(', ')
  end

end
