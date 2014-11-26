# Check all the events for feedback emails

class FeedbackEmailScheduler
  include Sidekiq::Worker
  include Sidetiq::Schedulable
  sidekiq_options :queue => :cron

  recurrence do
    hourly.minute_of_hour(0,30)
  end

  def perform
    events = Event.select{|e| (Status::Event.values_for_feedback_email.include? e.status) && (Time.now < e.event_start_time_utc + GlobalSetting.event_trailing_days.days)}
    events.each do |event|
      if (Time.now - event.event_start_time_utc.to_time)/60 > (GlobalSetting.review_sent_after * 60) and event.contact and !event.contact.email.empty? and event.contact.feedback_notifications? and event.feedback_status.nil? and Product.find_parent(event.product) == "managed_services"
        Sidekiq::Client.enqueue(SendFeedbackEmail, event.id)
      end
    end
  end
end
