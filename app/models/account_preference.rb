# == Schema Information
#
# Table name: account_preferences
#
#  id              :integer          not null, primary key
#  preference_type :string(255)
#  vendor_id       :integer
#  cuisine         :string(255)
#  disposition     :text
#  account_id      :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class AccountPreference < ApplicationModel

  belongs_to :account
  belongs_to :vendor

  validates :preference_type, presence: true
  validates :disposition, presence: true
  validate :vendor_or_cuisine

  def preference 
    case self.preference_type
    when Fooda::Preferences::Account.cuisine
      return self.cuisine
    when Fooda::Preferences::Account.vendor
      return self.vendor.name unless self.vendor.nil?
    end
    ""
  end

  def type_vendor?
    self.preference_type == Fooda::Preferences::Account.vendor
  end

  def type_cuisine?
    self.preference_type == Fooda::Preferences::Account.cuisine
  end

  def vendor_or_cuisine
    if (self.vendor_id.nil? || self.vendor_id.blank?) && (self.cuisine.nil? || self.cuisine.blank?)
      errors[:base] << ("You must select a Vendor or Cuisine")
    end
  end      

end