# == Schema Information
#
# Table name: vendor_preferences
#
#  id              :integer          not null, primary key
#  preference_type :string(255)
#  account_id      :integer
#  location_id     :integer
#  disposition     :string(255)
#  vendor_id       :integer
#

class VendorPreference < ApplicationModel

  belongs_to :account
  belongs_to :vendor
  belongs_to :location

  validates :preference_type, presence: true
  validates :disposition, presence: true
  validate  :account_or_location

  def preference 
    case self.preference_type
    when Fooda::Preferences::Vendor.account
      return self.account
    when Fooda::Preferences::Vendor.location
      return self.location
    end
    ""
  end

  def type_account?
    self.preference_type == Fooda::Preferences::Vendor.account
  end

  def type_cuisine?
    self.preference_type == Fooda::Preferences::Vendor.location
  end

  def account_or_location
    if (self.account.nil? || self.account.blank?) && (self.location.nil? || self.location.blank?)
      errors[:base] << ("You must select an Account or Location")
    end
  end      

end