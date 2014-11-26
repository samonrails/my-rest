# == Schema Information
#
# Table name: tokens
#
#  id            :integer          not null, primary key
#  identity_id   :integer
#  identity_type :string(255)
#  digest        :string(255)
#  accessed_at   :datetime
#  expires_at    :datetime
#  data          :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Token < ApplicationModel
  belongs_to :identity, polymorphic: true
  serialize :data, Hash

  before_create :generate_digest

  def to_param
    digest
  end

  def expired?
    Time.now > expires_at if expires_at
  end

  def generate_digest
    begin
      self[:digest] = SecureRandom.urlsafe_base64(32)
    end while Token.exists?(:digest => self[:digest])
  end
  
  def expire_token
    self.touch(:accessed_at)
    self.touch(:expires_at)
  end
end