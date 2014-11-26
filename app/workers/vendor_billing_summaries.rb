class VendorBillingSummaries
  include Sidekiq::Worker

  def perform(full_name, user_email, method, date_integer, no_vendors)
    date = Time.at(date_integer).in_time_zone("US/Central").to_datetime

    Rails.logger.warn "VendorBillingSummaries - Date: " + date.to_s + ", No Vendors: " + (!no_vendors.nil? && no_vendors).to_s 

    Event.vendors_with_completed_events_in_past_7days(date).each do |vendor_id, event_vendor_list|

      Rails.logger.warn "VendorBillingSummaries - Processing Vendor ID: " + vendor_id.to_s + ", Number of events: " + event_vendor_list.count.to_s

      # Create the document
      doc_info = Document.create_vendor_billing_summary_document({"date"=>date, "event_vendor_list"=>event_vendor_list})

      # Fetch the vendor
      vendor = Vendor.find(vendor_id)

      no_vendor_recipients_warning = false

      if no_vendors
        email_recipients = Email.vendor_billing_summaries.map{|c| c.email}
        bcc_recipients = nil
      else
        email_recipients = vendor.contacts.where(:billing_notifications => true).map{|c| c.email}
        bcc_recipients = Email.vendor_billing_summaries.map{|c| c.email}

        if email_recipients.count == 0
          # If the vendor doesn't have any contacts setup to receive billing summaries, then send
          # the email to the Fooda recipients, but change the subject line
          email_recipients = bcc_recipients
          bcc_recipients = nil
          no_vendor_recipients_warning = true
        end
      end

      # Loop sending emails
      email_recipients.each do |email|
        CateringReportMailer.vendor_billing_summary(email, bcc_recipients, full_name, user_email, method, doc_info["document_pdf"], doc_info["document_name"], vendor_id, no_vendor_recipients_warning).deliver
        Rails.logger.info "Sent Vendor Billing Summary for vendor ID " + vendor_id.to_s + " to " + email
      end

      unless no_vendors
        event_vendor_list.map{|ev| ev.vendor_billing_summary_sent_at = DateTime.now; ev.save}
      end

    end
  end
end
