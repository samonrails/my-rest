# == Schema Information
#
# Table name: vendor_documents
#
#  id                    :integer          not null, primary key
#  document_file_name    :string(255)
#  document_content_type :string(255)
#  document_file_size    :integer
#  vendor_insurance_id   :integer
#  user_id               :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class VendorDocument < ApplicationModel
  # attr_accessible :title, :body
  belongs_to :vendor_insurance
  belongs_to :user

  # validates_format_of :document_file_name, :with => %r{\.(docx|doc|pdf|zip)$}i
  validates_attachment_presence :document

  has_attached_file :document,
    :storage => :fog,
    :fog_credentials => {
      provider: "AWS",
      aws_access_key_id: AWS::Key,
      aws_secret_access_key: AWS::Secret,
      region: AWS::Region
    },
    :fog_public => true,
    :fog_directory => AWS::PrivateBucket,
    :path => "vendor_documents/:id.:extension"

  before_post_process :resize_images

  # Helper method to determine whether or not an attachment is an image.
  def image?
    document_content_type =~ %r{\.(docx|doc|pdf|zip)$}i
  end

  private

  def resize_images
    return false unless image?
  end
end