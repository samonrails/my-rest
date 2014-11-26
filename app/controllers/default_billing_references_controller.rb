class DefaultBillingReferencesController < ApplicationController
  respond_to :js
  authorize_resource
  
  def build_defaults
    params[:default_billing_reference].each do |dbr|
      default_billing_reference = DefaultBillingReference.find_or_create_by_user_id_and_billing_reference_id(current_user.id, dbr[:billing_reference_id].to_i)
      default_billing_reference.update_attribute(:choice, dbr[:choice])
      @dbr = default_billing_reference
    end
    @account = @dbr.billing_reference.account
  end
end
