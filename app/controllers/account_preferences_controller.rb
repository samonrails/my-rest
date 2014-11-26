class AccountPreferencesController < ApplicationController
  authorize_resource
  respond_to :html

  def show
    respond_with(@preference = AccountPreference.find(params[:id]), @account = current_account)
  end

  def edit
    @preference = current_account.account_preferences.find(params[:id])
  end

  def new
    respond_with(@preference = current_account.account_preferences.build)
  end

  def create
    @preference = preferences.create(permitted_params.account_preference)

    if @preference.save
      flash[:notice] = "Preference created."
      redirect_to account_path(current_account, :selected => "preferences")
    else
      flash[:error] = "Error creating Preference - " + @preference.errors.full_messages.join(", ")
      redirect_to account_path(current_account, :selected => "preferences")
    end
  end

  def update
    @preference = current_account.account_preferences.find(params[:id])
    if @preference.update_attributes(permitted_params.account_preference)
      flash[:notice] = "Preference updated."
      redirect_to account_path(current_account, :selected => "preferences")
    else
      flash[:error] = "Error updating Preference - " + @preference.errors.full_messages.join(", ")
      redirect_to account_path(current_account, :selected => "preferences")
    end
  end

  def destroy
    @preference = current_account.account_preferences.find(params[:id])
    begin
      @preference.destroy
      flash[:notice] = "Preference deleted."
    rescue ActiveRecord::DeleteRestrictionError => e
      flash[:error] = "Error destorying preference - " + e.to_s
    end
    redirect_to account_path(current_account, :selected => "preferences")
  end

  protected

    def preferences
      @preferences ||= current_account.account_preferences
    end

    def current_account
      @account ||= Account.find(params[:account_id])
    end

end