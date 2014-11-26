class AccountRolesController < ApplicationController
  authorize_resource
  respond_to :html, :json

  def create
    respond_with AccountRole.create(permitted_params.account_role)
  end

  def destroy
    AccountRole.destroy(params[:id])
    flash[:notice] = "Member deleted successfully."
    redirect_to :back
  end
  
  def update
    @account_role = AccountRole.find(params[:id])
    if @account_role.update_attributes(permitted_params.account_role)
      flash[:notice] = "Account Role updated successfully."
    else
      flash[:error] = "Error updating account role- " + @account_role.errors.full_messages.join(", ")
    end
    redirect_to account_path(@account_role.account, :selected => "membership")
  end
end


