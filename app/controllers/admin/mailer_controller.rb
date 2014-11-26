class Admin::MailerController < ApplicationController
  # Note: If params[:send] is true, queue a email job otherwise render the email html.
  load_and_authorize_resource class: false


  def catering_schedule_preview
    if params[:send]
      Sidekiq::Client.enqueue(CateringSchedulePreview, current_user.name, current_user.email, "Force Send")
      flash_and_redirect "Sent Email: Catering Schedule Preview.", admin_root_path(:selected => "email_management")
    else
      # Generates a web preview
      @events = Event.catering_schedule_preview
      @full_name = current_user.nil? ? "Automated" : "#{current_user.name} (#{current_user.email})"
      @method = "Web Preview"
      @status = [Status::Event.proposed, Status::Event.scheduled, Status::Event.active]
      @preview_date = Date.tomorrow.strftime("%a, %b #{Date.tomorrow.day.ordinalize}, %Y")
      render :file => 'catering_report_mailer/catering_schedule_preview.html.haml', :layout => false
    end
  end

  def end_of_day_sales_report
    if params[:send]
      Sidekiq::Client.enqueue(EndOfDaySalesReport, current_user.name, current_user.email, "Force Send")
      flash_and_redirect "Sent Email: End of Day Sales Report.", admin_root_path(:selected => "email_management")
    else
      # Generates a web preview
      @events = Event.end_of_day_sales_report
      @full_name = current_user.nil? ? "None" : "#{current_user.name} (#{current_user.email})"
      @method = "Web Preview"
      @preview_date = DateTime.now.strftime("%a, %b #{DateTime.now.day.ordinalize}, %Y")
      @status = [ "N/A" ]

      render :file => 'catering_report_mailer/end_of_day_sales_report.html.haml', :layout => false
    end
  end

  def vendor_billing_summaries
    if params[:send]
      Sidekiq::Client.enqueue(VendorBillingSummaries, current_user.name, current_user.email, "Force Send", Time.now.to_i, params[:no_vendors])
      flash_and_redirect "Sent Email: Vendor Billing Summaries.", admin_root_path(:selected => "email_management")
    else
      # Generates a web preview of the email body
      @vendor = Vendor.first
      render :file => 'catering_report_mailer/vendor_billing_summary.html.haml', :layout => false
    end
  end

  def event_scheduler_job
    Sidekiq::Client.enqueue(EventScheduler)
    flash_and_redirect "Event Scheduler Started.", admin_root_path(:selected => "event_schedules")
  end

  def insurance_expiration_report
    if params[:send]
      Sidekiq::Client.enqueue(InsuranceExpirationReport, current_user.name, current_user.email, "Force Send")
      flash_and_redirect "Sent Email: Insurance Expiration Report.", admin_root_path(:selected => "email_management")
    else
      # Generates a web preview of the email body
      @expirations = VendorInsurance.all.select{|vi| vi.insurance_expiration_date < Date.today+1.month && vi.insurance_expiration_date > Date.today-1.month}.sort_by{|vi| vi.vendor.name}
      render :file => 'catering_report_mailer/insurance_expiration_report.html.haml', :layout => false
    end
  end

  def event_feedback_email
    @event = Event.first
    @contact = @event.contact
    @tokens = @event.active_tokens.order('data').nil? ? 'xxxxx' : @event.active_tokens.order('data')
    render :file => 'notifier/send_feedback_email.html.erb', :layout => false
  end
end
