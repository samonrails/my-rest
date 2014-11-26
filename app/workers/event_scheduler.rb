class EventScheduler
  include Sidekiq::Worker
  include Sidetiq::Schedulable
  sidekiq_options :queue => :cron

  recurrence do
    weekly.day(1,2,3,4,5).hour_of_day(4)
  end

  def perform
    Rails.logger.info 'Event Scheduler - START'
    EventSchedule.find_each(&:process)
    Rails.logger.info 'Event Scheduler - END'
  end
end
