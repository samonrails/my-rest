# == Schema Information
#
# Table name: account_roles
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  account_id :integer
#  role       :string(255)      default("member")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AccountRole < ApplicationModel

  # Variables
  VALIDROLES = %w(member administrator)

  # Associations
  belongs_to :user
  belongs_to :account

  before_destroy :delete_defaults

  # Validations
  validates :role, inclusion: {in: VALIDROLES}
  validates_uniqueness_of :account_id, scope: :user_id
  validates :account_id, :user_id, presence: true

  # Instance Methods
  def join_date
    created_at
  end

  def is_admin?
    role == 'administrator'
  end

  # Class Methods
  def self.find_record(account_id, user_id)
    self.find_by_account_id_and_user_id(account_id, user_id)
  end

  def delete_defaults 
    user = User.find(self.user_id)
    default_card = Card.find_by_id user.default_billing_id
    default_location = Location.find_by_id(user.default_account_location_id)
    default_contact = Contact.find_by_id(user.default_contact_id)

    #remove default on account payment method owned by current account 
    if self.account_id == user.default_account_id
      user.update_attributes(default_account_id: nil, payment_method: nil)
    end

    #remove default card owned by current account
    if default_card and (default_card.account_id == self.account_id)
      user.update_attributes(default_billing_id: nil)
    end

    #remove default location owned by current account
    if default_location and (default_location.account_id == self.account_id)
      user.update_attributes(default_account_location_id: nil)
    end

    #remove default contact owned by current account
    if default_contact and (default_contact.account_id == self.account_id)
      user.update_attributes(default_contact_id: nil)
    end

    #remove default billing references owned by current account
    user.default_billing_references.each do |br|
      if self.account_id == br.billing_reference.account_id
        br.destroy
      end
    end
  end
end
