class CustomFailure < Devise::FailureApp
  def redirect_url
    if warden_options[:scope] == :user
      warden_options[:attempted_path].starts_with?('/catering') ? catering_login_path : login_path
    else
      root_path
    end
  end
  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end
end