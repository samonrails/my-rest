class Admin::DashboardController < ApplicationController
  
  respond_to :html

  def index
    authorize! :read, :admin_dashboard
    options = {:artificial_attributes => {"name" => "buildings.name", "market" => "markets.name", "address" => "addresses.address1"}}
    respond_to do |format|
      format.html do
        if params[:xls]
          redirect_to :action => "index", :format => "xls", :searchable => params[:searchable], :direction => params[:direction], :sort => params[:sort]
        else
          @buildings = Kaminari.paginate_array(Building.includes(:market).includes(:address).search_sort_paginate(params, options)).page(params[:page])
          @markets = Market.all
          @pricing_tiers = PricingTier.all
          @new_catering_sales = Email.where( :email_list => "new_catering_sales" )
          @catering_schedule_preview = Email.where( :email_list => "catering_schedule_preview" )
          @vendor_billing_summaries = Email.where( :email_list => "vendor_billing_summaries" )
          @insurance_expiration_report = Email.where( :email_list => "insurance_expiration_report" )
        end
      end
      format.xls do
        @buildings = Building.includes(:market).includes(:address).search_sort_paginate(params, options)
        headers["Content-Disposition"] = "attachment; filename=\"buildings.xls\""
      end
    end
  end

end
