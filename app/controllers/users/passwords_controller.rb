class Users::PasswordsController < Devise::PasswordsController

  layout 'catering/catering', only: [:catering_forgot, :catering_recover]

  def resource_params
    params.require(:user).permit(:login, :email, :password, :password_confirmation, :role, :reset_password_token, :catering)
  end

  def catering_forgot
    render layout: 'catering/catering'
  end

  def catering_recover
    self.resource = resource_class.new
    resource.reset_password_token = params[:reset_password_token]
    render layout: 'catering/catering'
  end

  def catering_update
    self.resource = resource_class.reset_password_by_token(resource_params)
    if params[:user][:welcome_email]
      resource.update_attributes(first_name: params[:user][:first_name], last_name: params[:user][:last_name], position: params[:user][:position], phone_number: params[:user][:phone_number], agreed_terms_at: Time.now)
      contact = resource.contacts.where("self_created").first if resource
      contact.update_attributes(phone_number: params[:user][:phone_number], position: params[:user][:position]) if contact
    end
    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message(:notice, flash_message) if is_navigational_format?
      sign_in(resource_name, resource)
      respond_with resource, :location => after_resetting_password_path_for(resource)
    else
      flash[:error] = resource.errors.full_messages.join(', ')
      forgot = params[:user][:welcome_email] ? nil : true
      redirect_path = params[:user][:catering] ? catering_recover_password_path(reset_password_token: params[:user][:reset_password_token], forgot: forgot) : edit_user_password_path(reset_password_token: params[:user][:reset_password_token])
      redirect_to redirect_path
    end
  end

  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    if successfully_sent?(resource)
      respond_with({}, :location => after_sending_reset_password_instructions_path_for(resource_name))

      Analytics.track(
          user_id: 'Forgot Password', 
          event: 'Forgot Password', 
          properties: { 'email' => resource_params["email"] }
      )

    else
      flash[:error] = "Email not found"
      redirect_path = params[:user][:catering] ? catering_forgot_password_path : new_user_password_path
      redirect_to redirect_path
    end
  end

  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    if resource.errors.empty?
      resource.unlock_access! if unlockable?(resource)
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message(:notice, flash_message) if is_navigational_format?
      sign_in(resource_name, resource)
      respond_with resource, :location => after_resetting_password_path_for(resource)
    else
      flash[:error] = resource.errors.full_messages.join(', ')
      redirect_path = params[:user][:catering] ? catering_recover_password_path(reset_password_token: params[:user][:reset_password_token]) : edit_user_password_path(reset_password_token: params[:user][:reset_password_token])
      redirect_to redirect_path
    end
  end
  

  private :resource_params

  protected
    def after_resetting_password_path_for(resource)
      after_sign_in_path_for(resource)
    end

    # The path used after sending reset password instructions
    def after_sending_reset_password_instructions_path_for(resource_name)
      params[:user][:catering] ? catering_login_path : new_session_path(resource_name)
    end

end
