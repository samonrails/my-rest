class SelectEventBillingReferencesController < ApplicationController
  authorize_resource
  respond_to :html

  def create
    
    @reference = SelectEventBillingReference.new(permitted_params.select_event_billing_reference)
    if @reference.save
      flash[:notice] = "Billing reference created."
    else
      flash[:error] = "Error creating Billing reference - " + @reference.errors.full_messages.join(", ")
    end
    redirect_to :back
  end

  def update
    @reference = select_event_billing_references.find(params[:id])
    if @reference.update_attributes(permitted_params.billing_reference)
      flash[:notice] = "Billing reference updated."
    else
      flash[:error] = "Error updating Billing reference."
    end
    redirect_to :back
  end

  def destroy
    begin
      SelectEventBillingReference.where(:select_event_id => params[:select_event_id], :billing_reference_id => params[:id]).delete_all
      flash[:notice] = "Reference deleted."
    rescue ActiveRecord::DeleteRestrictionError => e
      flash[:error] = "Error destorying reference - " + e.to_s
    end
    redirect_to :back
  end
end
