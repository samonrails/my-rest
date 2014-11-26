# == Schema Information
#
# Table name: zip_codes
#
#  id         :integer          not null, primary key
#  zipcode    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ZipCode < ApplicationModel
  has_and_belongs_to_many :markets

  def self.markets_by_zip_code zip_code
    zip_code = zip_code.to_s
    cid = 'Market_' + Market.new.get_cache_counter.to_s + '_' + zip_code
    markets = []
    markets = (Rails.cache.read(cid) || []) unless ENV['disable_caching'] == '1'
    if markets.empty?
      zipcode = ZipCode.find_by_zipcode(zip_code)
      markets = zipcode.markets if zipcode.present?
      Rails.cache.write(cid, markets, expires_in: 1.week)
    end
    markets
  end

end
