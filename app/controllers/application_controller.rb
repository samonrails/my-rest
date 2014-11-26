class ApplicationController < ActionController::Base
  protect_from_forgery
  force_ssl

  before_filter :authenticate_user!, :mailer_set_url_options
  check_authorization :unless => :do_not_check_authorization?
  include UrlHelper

  rescue_from CanCan::AccessDenied do |exception|    
    flash[:alert] = "Access Denied." + (current_user ? "You do not have access to this page." : "Please sign in.")
    render "errors/not_found", layout: false
  end

  private

    def permitted_params
      @permitted_params ||= PermittedParams.new(params, current_user)
    end

    helper_method :permitted_params

    def flash_and_redirect(message, route)
      flash[:notice] = message
      redirect_to route
    end

    helper_method :flash_and_redirect

    def is_active
      if current_user and current_user.disable?
        flash[:notice] = "This account is no more active."
        sign_out current_user
      end
    end

    def do_not_check_authorization?
      respond_to?(:devise_controller?)
    end
  
    def after_sign_in_path_for(resource)
      if params[:user] && params[:user][:catering]
        session[:user_return_to] || catering_path
      else
        session[:user_return_to] || root_path
      end
    end

    def mailer_set_url_options
      ActionMailer::Base.default_url_options = {:host => request.host_with_port}
    end

end
