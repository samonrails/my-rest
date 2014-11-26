class Users::SessionsController < Devise::SessionsController

  layout 'catering/catering', only: [:catering_new]

  def catering_new
    render layout: 'catering/catering'
  end

  def catering_logout
    redirect_path = catering_path
    
    user_account = SegmentIO.user_account_information_for_segment_io current_user
    Analytics.track(
        user_id: current_user.id, 
        event: 'Logged Out', 
        properties: user_account
    )
    
    
    
    
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    set_flash_message :notice, :signed_out if signed_out && is_navigational_format?

    respond_to do |format|
      format.all { head :no_content }
      format.any(*navigational_formats) { redirect_to redirect_path }
    end
  end
  
  def create
    self.resource = warden.authenticate(auth_options)
    if self.resource
      set_flash_message(:notice, :signed_in) if is_navigational_format?
      sign_in(resource_name, resource)
      
      # We want to identify a user with any relevant information as soon as they log-in or sign-up
      user_identify_traits = SegmentIO.identify_traits current_user 
      
      Analytics.identify(
          user_id: current_user.id,
          traits: user_identify_traits
      )

     
      # Track that they logged in

      user_account = SegmentIO.user_account_information_for_segment_io current_user
      
      Analytics.track(
          user_id: current_user.id, 
          event: 'Logged In', 
          properties: user_account
      )
      
      respond_with resource, :location => after_sign_in_path_for(resource)
    else
      failed_path = params[:user][:catering] ? catering_login_path : login_path
      flash[:error] = "Invalid email or password."
      redirect_to failed_path
    end
  end
end