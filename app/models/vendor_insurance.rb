# == Schema Information
#
# Table name: vendor_insurances
#
#  id                        :integer          not null, primary key
#  building_id               :integer
#  vendor_id                 :integer
#  user_id                   :integer
#  insurance_effective_date  :date
#  insurance_expiration_date :date
#  waiver_subrogation        :string(255)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

class VendorInsurance < ApplicationModel
  # attr_accessible :title, :body
  belongs_to :vendor
  belongs_to :building
  belongs_to :user
  has_many :vendor_documents, :dependent => :destroy
  validates :building_id,:insurance_effective_date,:insurance_expiration_date, :presence => true
  
  validate :start_must_be_before_end_time

  def start_must_be_before_end_time
    valid = insurance_effective_date && insurance_expiration_date && insurance_effective_date < insurance_expiration_date
    errors.add(:insurance_expiration_date, "should be greater than the insurance effective date.") unless valid
  end
end