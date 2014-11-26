# Preview of tomorrow's catering schedule

class EndOfDaySalesReport
  include Sidekiq::Worker
  include Sidetiq::Schedulable
  sidekiq_options :queue => :cron

  recurrence do
    weekly.day(1,2,3,4,5).hour_of_day(21)
  end

  def perform
    full_name, user_email, method = "Automated", "snappea@fooda.com", "4:00 Scheduled"
    Email.end_of_day_sales_report.each do |email|
      CateringReportMailer.end_of_day_sales_report(email, full_name, user_email, method).deliver
      Rails.logger.warn "Sent Fooda Sales end of day email report to #{email.email}" 
    end
  end
end
