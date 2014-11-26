# == Schema Information
#
# Table name: contacts
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  position               :string(255)
#  email                  :string(255)
#  phone_number           :string(255)
#  mobile_number          :string(255)
#  fax_number             :string(255)
#  primary_contact        :boolean
#  billing_notifications  :boolean
#  event_notifications    :boolean
#  sms                    :boolean
#  account_id             :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  vendor_id              :integer
#  feedback_notifications :boolean          default(TRUE)
#  user_id                :integer
#  contact_type           :string(255)      default("Internal")
#  self_created           :boolean          default(FALSE)
#  deleted_at             :datetime
#

class Contact < ApplicationModel
  acts_as_paranoid

  belongs_to :account
  belongs_to :vendor
  belongs_to :user
  has_many :events
  has_many :reviews

  before_destroy :delete_default_contact

  validates :name, presence: true
  validates :email, :email => true

  # To find public contacts
  scope :public, lambda{ where(contact_type: 'Public')}

  default_scope order 'name'
  
  def to_s
    name
  end

  def personal?
    !self.user_id.nil? and self.account_id.nil? and self.vendor_id.nil?
  end

  # Who owns this contact card? Hierarchy of Account, Vendor then User
  def party_owner
    if !self.account_id.nil?
      self.account.name
    elsif !self.vendor_id.nil?
      self.vendor.name
    elsif !self.user_id.nil?
      "Personal Contact"
    else
      "-"
    end
  end

  def default user_id
    user = User.find(user_id)
    user.default_contact_id = self.id
    user.save
  end

  def delete_default_contact
    users = User.find_all_by_default_contact_id(self.id)
    users.each do |user|
      user.update_attributes(default_contact_id: nil)
    end
  end

end
