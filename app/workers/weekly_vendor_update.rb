class WeeklyVendorUpdate
  include Sidekiq::Worker
  include Sidetiq::Schedulable
  sidekiq_options :queue => :cron

  recurrence do
    weekly.day(0).hour_of_day(0)
  end

  def perform
    Rails.logger.warn "Force Yelp Roll Up:"
    Vendor.find_each do |vendor|
      unless vendor.yelp_id.nil?
        Yelp.update vendor
      else
        Yelp.find vendor 
      end
    end

    Vendor.find_each do |v| 
      if v.yelp_id.nil?
        Rails.logger.warn "#{v.name}: #{v.id}" 
      end
    end
  end
end
