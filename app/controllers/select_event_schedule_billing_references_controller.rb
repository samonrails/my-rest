class SelectEventScheduleBillingReferencesController < ApplicationController
  authorize_resource
  respond_to :html

  def show
    @reference = BillingReference.find(params[:id])
  end

  def create
    @reference = SelectEventScheduleBillingReference.new(permitted_params.select_event_schedule_billing_reference)
    if @reference.save
      flash[:notice] = "Billing reference created."
    else
      flash[:error] = "Error creating Billing reference - " + @reference.errors.full_messages.join(", ")
    end
    redirect_to :back
  end

  def destroy
    begin
      SelectEventScheduleBillingReference.where(:select_event_schedule_id => params[:account_id], 
                                                :billing_reference_id => params[:id]).delete_all
      flash[:notice] = "Reference deleted."
    rescue ActiveRecord::DeleteRestrictionError => e
      flash[:error] = "Error destorying reference - " + e.to_s
    end
    redirect_to :back
  end
end
