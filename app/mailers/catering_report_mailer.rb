class CateringReportMailer < ActionMailer::Base
  default from: "snappea@fooda.com"

  def catering_schedule_preview(email, full_name, user_email, method)
    # Send an email
    @events = Event.catering_schedule_preview
    @full_name = "#{full_name} (#{user_email})"
    @method = method
    @preview_date = Date.tomorrow.strftime("%a, %b #{Date.tomorrow.day.ordinalize}, %Y")
    @status = [Status::Event.proposed, Status::Event.scheduled, Status::Event.active]

    mail(:to => email.email, :subject => "Fooda Report - Catering Schedule Preview")
  end

  def end_of_day_sales_report(email, full_name, user_email, method)
    # Send an email
    @events = Event.end_of_day_sales_report
    @full_name = "#{full_name} (#{user_email})"
    @method = method
    @preview_date = DateTime.now.strftime("%a, %b #{DateTime.now.day.ordinalize}, %Y")
    @status = [ "N/A" ]

    mail(:to => email.email, :subject => "Fooda Report - End of Day Sales")
  end

  def vendor_billing_summary(email, bcc_recipients, full_name, user_email, method, document_pdf, document_name, vendor_id, no_vendor_recipients_warning)
    # Send an email
    @vendor = Vendor.find(vendor_id)
    @full_name = "#{full_name} (#{user_email})"
    @method = method
    attachments[document_name] = document_pdf

    subject = no_vendor_recipients_warning ? "WARNING: No Vendor Recipients for Fooda - Vendor Billing Summary" : "Fooda - Vendor Billing Summary";

    if bcc_recipients && bcc_recipients.count > 0
      Rails.logger.warn "Sent Vendor Billing Summary Email to " + email + " with BCC: " + bcc_recipients.join(", ") 
      mail(:to => email, bcc: bcc_recipients, :subject => subject, :from => "accounting@fooda.com")
    else
      Rails.logger.warn "Sent Vendor Billing Summary Email to " + email + " without BCC"
      mail(:to => email, :subject => subject, :from => "accounting@fooda.com")
    end
  end

  def insurance_expiration_report(email, full_name, user_email, method, expirations)
    @full_name = "#{full_name} (#{user_email})"
    @method = method
    @expirations = expirations
    mail(:to => email.email, :subject => "Fooda - Vendor Insurance Expiration Report")
  end

end
