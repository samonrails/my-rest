class BillingReferencesController < ApplicationController
  authorize_resource
  respond_to :html

  def show
    @reference = BillingReference.find(params[:id])
    @entity = current_entity
  end

  def edit
    @reference = billing_references.find(params[:id])
    @entity = current_entity
    if(current_event)
      @account_references = @event.account.billing_references.map(&:name)
      @account_reference_choices = @event.account.billing_references.as_tag_list_with_name
      render :create_update_for_event
    end
  end

  def new
    @reference = billing_references.build
    if(current_event)
      @account_references = @event.account.billing_references
      @account_reference_choices = @event.account.billing_references.as_tag_list_with_name
      render :create_update_for_event
    end
  end

  def create
    @reference = billing_references.new(permitted_params.billing_reference)
    if @reference.save
      flash[:notice] = "Billing reference created."
    else
      flash[:error] = "Error creating Billing reference - " + @reference.errors.full_messages.join(", ")
    end
    redirect_to :back
  end

  def update
    @reference = billing_references.find(params[:id])
    if @reference.update_attributes(permitted_params.billing_reference)
      flash[:notice] = "Billing reference updated."
    else
      flash[:error] = "Error updating Billing reference."
    end
    redirect_to :back
  end

  def destroy
    @reference = billing_references.find(params[:id])
    begin
      @reference.destroy
      flash[:notice] = "Reference deleted."
    rescue ActiveRecord::DeleteRestrictionError => e
      flash[:error] = "Error destorying reference - " + e.to_s
    end
    redirect_to :back
  end

  def get_choices
    reference = BillingReference.find(params[:id])
    @list = reference[:data]
    respond_to do |format|
      format.json { render :json => @list }
    end
  end

  protected
    def billing_references
      @reference = current_account ? current_account.billing_references : current_event.billing_references
    end

    def current_account
      @account ||= Account.find(params[:account_id]) if params[:account_id]
    end

    def current_event
      @event ||= Event.find(params[:event_id]) if params[:event_id]
    end

    def current_entity
      @entity = current_account ? current_account : current_event
    end
end