class Admin::ManagedServicesReportsController < ApplicationController
  load_and_authorize_resource class: false
  respond_to :html, :js

  def index
    respond_to do |format|
      options = {:artificial_attributes => {"vendor"=>"vendors.name", "account"=>"accounts.name", "date" => "event_start_time", "sales_rep" => "accounts.sales_rep.name", "market" => "markets.name", "account_executive" => "users.email"}}
      format.html do
        if params[:xls]
          redirect_to :action => "index", :format => "xls", :searchable => params[:searchable], :direction => params[:direction], :sort => params[:sort]
        else
          @events = Event.includes([:account => :account_exec]).includes(:vendors).includes([:location => [:building => :market]]).search_sort_paginate(params, options)
          @events = @events.includes(:order).where("catering_orders.event_id is not null") if defined? params[:searchable][:order_method] and params[:searchable][:order_method] == "Self Service"
          @events, @levels = do_loops_events(@events, params)
          @view_parameters = params
        end
      end
      format.xls do
        @view_parameters = params
        @events = Event.includes([:account => :account_exec]).includes(:vendors).includes([:location => [:building => :market]]).search_sort_paginate(@view_parameters, options)
        @events = @events.includes(:order).where("catering_orders.event_id is not null") if defined? params[:searchable][:order_method] and params[:searchable][:order_method] == "Self Service"
        @events, @levels = do_loops_events(@events, @view_parameters)
        @current_user = current_user
        headers["Content-Disposition"] = "attachment; filename=\"managed_services.xls\""
      end
    end
  end

  def do_loops_events events, params
    levels = 0
    unless defined?(params[:searchable][:outer_group]).nil? || params[:searchable][:outer_group].empty?
      events = do_outer_loop events, params
      levels += 1
      unless defined?(params[:searchable][:inner_group]).nil? || params[:searchable][:inner_group].empty?
        events = do_inner_loop events, params
        levels += 1
      end
    end
    [events, levels]
  end

  def do_outer_loop events, params
    case params[:searchable][:outer_group]
      when "Sales Rep"
        events = events.group_by{|e| (e.account.sales_rep.nil? ? "" : e.account.sales_rep.name)}
      when "Date"
        events = events.group_by{|e| e.event_start_time.midnight}
      when "Account"
        events = events.group_by{|e| e.account.name}
      when "Vendor"
        events = events.group_by{|e| e.event_vendors.map { |v| v.vendor.name }.join(", ") unless e.event_vendors.nil?}
      when "Account Executive"
        events = events.group_by{|e| (e.account.account_exec.nil? ? "" : e.account.account_exec.name)}
      else
        events = events
      end
  end

  def do_inner_loop events, params
    case params[:searchable][:inner_group]
      when "Sales Rep"
        events.each{ |k,v| events[k] = v.group_by{|e| (e.account.sales_rep.nil? ? "" : e.account.sales_rep.name)} }
      when "Date"
        events.each{ |k,v| events[k] = v.group_by{|e| e.event_start_time.midnight} }
      when "Account"
        events.each{ |k,v| events[k] = v.group_by{|e| e.account.name} }
      when "Vendor"
        events.each{ |k,v| events[k] = v.group_by{|e| e.event_vendors.map { |v| v.vendor.name }.join(", ") unless e.event_vendors.nil?}}
      when "Account Executive"
        events.each{ |k,v| events[k] = v.group_by{|e| (e.account.account_exec.nil? ? "" : e.account.account_exec.name)} }
      end
      events
  end

end

