# == Schema Information
#
# Table name: assets
#
#  id                    :integer          not null, primary key
#  description           :string(255)
#  resource_file_name    :string(255)
#  resource_content_type :string(255)
#  resource_file_size    :integer
#  resource_updated_at   :datetime
#  owner_type            :string(255)
#  owner_id              :integer
#  is_default            :boolean          default(FALSE)
#

class Asset < ApplicationModel
  has_attached_file :resource,
    :storage => :fog,
    :fog_credentials => {
      provider: "AWS",
      aws_access_key_id: AWS::Key,
      aws_secret_access_key: AWS::Secret,
      region: AWS::Region
    },
    :fog_public => true,
    :fog_directory => AWS::PrivateBucket,
    :path => "assets/:style/:id.:extension",
    :styles => { :thumb => "100x100>" }

    belongs_to :owner, :polymorphic => true
    
    validates :resource, :attachment_presence => true

  after_create :set_is_default

  def set_is_default
    self.update_attributes(:is_default => true) if self.owner and !self.owner.default_image
  end

end