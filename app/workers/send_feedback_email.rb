# Send the emails generated from the Feedback Email Scheduler

class SendFeedbackEmail
  include Sidekiq::Worker

  def perform(event_id)
    event = Event.find(event_id)
    event.create_active_tokens
    Notifier.send_feedback_email(event).deliver
    event.update_attributes(:feedback_status => "sent")
  end
end
