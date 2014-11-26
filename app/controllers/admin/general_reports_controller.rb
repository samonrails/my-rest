class Admin::GeneralReportsController < ApplicationController
  load_and_authorize_resource class: false
  respond_to :html, :js

  def index
    respond_to do |format|
      format.html do
        if params[:xls]
          redirect_to :action => "index", :format => "xls", :searchable => params[:searchable], :direction => params[:direction], :sort => params[:sort]
        else
          @accounts = Account.search_sort_paginate(params)
        end
      end
      format.xls do
        @accounts = Account.search_sort_paginate(params)
        @current_user = current_user
        headers["Content-Disposition"] = "attachment; filename=\"new_audience_report.xls\""
      end
    end
  end
end

