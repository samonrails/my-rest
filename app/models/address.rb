# == Schema Information
#
# Table name: addresses
#
#  id       :integer          not null, primary key
#  name     :string(255)
#  address1 :string(255)
#  address2 :string(255)
#  city     :string(255)
#  state    :string(255)
#  zip_code :string(255)
#  country  :string(255)
#

include ActionView::Helpers::TextHelper

class Address < ApplicationModel

  after_initialize :initial_values

  def initial_values
    self.country ||= "United States"
    self.name ||= ""
    self.address1 ||= ""
    self.address2 ||= ""
    self.city ||= ""
    self.state ||= ""
    self.zip_code ||= ""
  end

  def to_s
    "#{address1}\n#{address2}\n#{city}, #{state} #{zip_code}"
  end

  def to_s_inline
    "#{address1} #{address2} #{city}, #{state} #{zip_code}"
  end

  def to_html
    address = ""
    address << "#{self.address1}<br>" unless self.address1.empty? 
    address << "#{self.address2}<br>" unless self.address2.empty?
    address << "#{self.city}, "       unless self.city.empty?
    address << "#{self.state} "       unless self.state.empty?
    address << "#{self.zip_code}"     unless self.zip_code.empty?
    address.html_safe
  end

end