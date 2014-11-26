class ContactsController < ApplicationController
  authorize_resource
  respond_to :html

  def show
    respond_with(@contact = Contact.find(params[:id]), @party = current_party)
  end

  def edit
    @contact = current_party.contacts.find(params[:id])
  end

  def new
    respond_with(@contact = current_party.contacts.build)
  end

  def create
    @contact = contacts.create(permitted_params.contact)

    if @contact.save
      flash[:notice] = "Contact created."
      redirect_to current_party_path
    else
      flash[:error] = "Error creating Contact - " + @contact.errors.full_messages.join(", ")
      redirect_to current_party_path
    end
  end

  def update
    @contact = current_party.contacts.find(params[:id])
    if @contact.update_attributes(permitted_params.contact)
      flash[:notice] = "Contact updated."
      redirect_to current_party_path
    else
      flash[:error] = "Error updating Contact - " + @contact.errors.full_messages.join(", ")
      redirect_to current_party_path
    end
  end

  def destroy
    @contact = current_party.contacts.find(params[:id])
    begin
      @contact.destroy
      flash[:notice] = "Contact deleted."
    rescue ActiveRecord::DeleteRestrictionError => e
      flash[:error] = "Error deleting Contact. - " + e.to_s
    end
    redirect_to current_party_path
  end

  def restore
    contact = current_party.contacts.with_deleted.find params[:id]
    if contact.update_attributes(deleted_at: nil)
      flash[:notice] = "Contact restored."
      redirect_to current_party_path
    else
      flash[:error] = "Error restoring contact."
      redirect_to current_party_path
    end
  end

  protected

    def contacts
      @contacts ||= current_party.contacts
    end

    def current_party
      @party = !params[:account_id].nil? ? Account.find(params[:account_id]) : Vendor.find(params[:vendor_id])
    end

    def current_party_path
      path_name = send("#{@party.class.name.downcase}_path".to_sym, current_party, :selected => "contacts")
    end

end