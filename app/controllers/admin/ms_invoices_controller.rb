class Admin::MsInvoicesController < ApplicationController
  load_and_authorize_resource class: false
  respond_to :html, :js
  
  def index
    respond_to do |format|
      options = {:artificial_attributes => {"market" => "markets.name"}}
      format.html do
        if params[:xls]
          redirect_to :action => "index", :format => "xls", :searchable => params[:searchable], :direction => params[:direction], :sort => params[:sort]
        else
          @events = Event.includes([:location => [:building => :market]]).search_sort_paginate(params, options).where("status != ?", "canceled").order("events.id DESC")
        end
      end
      format.xls do
        @events = Event.includes([:location => [:building => :market]]).search_sort_paginate(params, options).where("status != ?", "canceled").order("events.id DESC")
        headers["Content-Disposition"] = "attachment; filename=\"ms-invoice.xls\""
      end
    end
  end
end
