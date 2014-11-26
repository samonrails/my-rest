# == Schema Information
#
# Table name: cards
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  token      :string(255)
#  nickname   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :integer
#

class Card < ApplicationModel
  attr_accessible :nickname, :token, :user_id, :account_id
  belongs_to :user
  belongs_to :account

  def self.html_address address
    pretty = ""
    return pretty unless defined? address

    pretty << "#{address.street_address}<br>" unless address.street_address.nil? or address.street_address.empty? 
    pretty << "#{address.extended_address}<br>" unless address.extended_address.nil? or address.extended_address.empty?
    pretty << "#{address.locality}, " unless address.locality.nil? or address.locality.empty?
    pretty << "#{address.region} " unless address.region.nil? or address.region.empty?
    pretty << "#{address.postal_code}" unless address.postal_code.nil? or address.postal_code.nil?

    pretty.html_safe
  end

    
  def self.delete_card_meta token
    card_meta = Card.find_by_token token
    if card_meta.present?
       users = User.find_all_by_default_billing_id card_meta.id
       users.each do |user|
         user.update_attributes(default_billing_id: nil)
      end
    end
    card_meta.destroy
  end

end
