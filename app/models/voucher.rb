# == Schema Information
#
# Table name: vouchers
#
#  id               :integer          not null, primary key
#  voucher_group_id :integer
#  token            :string(255)
#  expires_at       :datetime
#  redeemed_at      :datetime
#  redeemed_by_id   :integer
#  status           :string(255)      default("unused")
#

class Voucher < ActiveRecord::Base
  belongs_to :voucher_group
  belongs_to :redeemed_by, class_name: 'User', foreign_key: 'redeemed_by_id'
  
  validates :voucher_group_id, :presence => true
  
  after_create :tokenize

  scope :valid, lambda { where(status: "unused")}
  scope :expired, lambda { where(status: "expired")}
  scope :redeemed, lambda { where(status: "redeemed")}

  private 
    def tokenize
      hashids = Hashids.new( PopupVoucher::Salt, PopupVoucher::MinimumLength, PopupVoucher::Alphabet )
      token = hashids.encrypt( voucher_group_id, id )
      self.update_attribute( :token, token )
    end
end
