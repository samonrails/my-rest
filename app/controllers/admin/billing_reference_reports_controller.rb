class Admin::BillingReferenceReportsController < ApplicationController
  load_and_authorize_resource class: false
  respond_to :html, :js

  def index
    respond_to do |format|

      format.html do
        if defined?(params[:searchable][:account])
          @account = Account.where(:name => params[:searchable][:account]).first if Account.where(:name => params[:searchable][:account]).count > 0
        end

        if params[:xls] && !params[:meta_data].nil? && params[:meta_data] == "billing_references"
          redirect_to :action => "export_billing_references", :format => "xls", :searchable => params[:searchable], :direction => params[:direction], :sort => params[:sort]
        end
      end

    end
  end

  def export_billing_references
    if defined?(params[:searchable][:account])
      @account = Account.where(:name => params[:searchable][:account]).first if Account.where(:name => params[:searchable][:account]).count > 0
    end
   
    respond_to do |format|
      format.xls do
        current_user = current_user
        headers["Content-Disposition"] = "attachment; filename=\"billing_reference_report.xls\""  
      end

    end
  end

end

