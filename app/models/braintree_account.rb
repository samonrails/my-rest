# == Schema Information
#
# Table name: braintree_accounts
#
#  id            :integer          not null, primary key
#  resource_id   :integer
#  resource_type :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  braintree_id  :string(255)
#

class BraintreeAccount < ApplicationModel

  # Associations
  belongs_to :resource, :polymorphic => true

  # Callbacks
  before_create :create_account unless Rails.env.test?

  def create_account
    result = Braintree::Customer.create( email: (self.resource.respond_to?(:email) ? self.resource.email : nil), 
                                         first_name: self.resource.first_name, 
                                         last_name: self.resource.last_name )
    if result.success?
      self.braintree_id = result.customer.id
      Rails.logger.info "Created Braintree Account for #{resource.name}" 
    else
      Rails.logger.error "Error Creating Braintree account for #{resource.name} - #{result.message}"
    end
  end

end
