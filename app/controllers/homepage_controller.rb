class HomepageController < ApplicationController
  skip_before_filter :authenticate_user! , :only => [:index]

  def index
    if current_user 
      authorize! :read, :dashboard
      @open_issues = Kaminari.paginate_array(current_user.opened_assigned_issues).page(params[:open_page]).per(10)
      @closed_issues = Kaminari.paginate_array(current_user.closed_assigned_issues).page(params[:closed_page]).per(10)
      @unclaimed_events = Kaminari.paginate_array(Event.unclaimed_events.joins(:order).sort.reverse).page(params[:unclaimed_events]).per(10)
      @my_events = Kaminari.paginate_array(current_user.events.opened).page(params[:my_events]).per(10)
      @completed_events = Kaminari.paginate_array(current_user.events.completed).page(params[:completed_events]).per(10) 
      @canceled_events = Kaminari.paginate_array(current_user.events.canceled).page(params[:canceled_events]).per(10)
      respond_to do |format|
        format.html
        format.json {render json: {open_issues: @open_issues, closed_issues: @closed_issues}}
        format.js
      end
    else

    end
  end
end
