class Users::RegistrationsController < Devise::RegistrationsController

  def resource_params
    params.require(:user).permit(:login, :email, :password, :password_confirmation, :role, :first_name, :last_name, :created_by)
  end

  private :resource_params

end
