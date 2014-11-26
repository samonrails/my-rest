# Report on the catering sales made today

class CateringSchedulePreview
  include Sidekiq::Worker
  include Sidetiq::Schedulable
  sidekiq_options :queue => :cron

  recurrence do
    weekly.day(1,2,3,4,5).hour_of_day(21)
  end

  def perform
    full_name, user_email, method = "Automated", "snappea@fooda.com", "4:00 Scheduled"
    Email.catering_schedule_preview.each do |email|
      CateringReportMailer.catering_schedule_preview(email, full_name, user_email, method).deliver
      Rails.logger.warn "Sent Fooda catering schedule preview email report to #{email.email}" 
    end
  end
end
