class SearchController < ApplicationController
  # Looks like it's not neccessary here
  # authorize_resource
  respond_to :html

  def index
    render :partial => "search/result", :collection => results
  end

  protected
    def results
      Fooda::Search.perform(params[:q], filter: params[:filter])
    end
end