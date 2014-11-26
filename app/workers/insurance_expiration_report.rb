class InsuranceExpirationReport
  include Sidekiq::Worker
  include Sidetiq::Schedulable
  sidekiq_options :queue => :cron

  recurrence do
    monthly.day_of_month(1,15).hour_of_day(22)
  end

  def perform
    full_name, user_email, method = "Automated", "snappea@fooda.com", "5:00 Scheduled"
    expirations = VendorInsurance.all.select{|vi| vi.insurance_expiration_date < Date.today+1.month && vi.insurance_expiration_date > Date.today-1.month}.sort_by{|vi| vi.vendor.name}
    if (expirations.count > 0)
      Email.insurance_expiration_report.each do |email|
        CateringReportMailer.insurance_expiration_report(email, full_name, user_email, method, expirations).deliver
        Rails.logger.warn "Sent insurance expiration report to #{email.email}" 
      end
    end
  end
end
