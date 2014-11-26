class DontSpamFeedbackEmailsWhenYouDeploy < ActiveRecord::Migration
  def up
    events = Event.select do |e| 
      (Status::Event.values_for_feedback_email.include? e.status) && (Time.now < e.event_start_time + GlobalSetting.event_trailing_days.days)
    end

    events.map do |event| 
      if (Time.now - event.event_start_time.to_time)/60 > (GlobalSetting.review_sent_after * 60) and !event.contact_id.nil? and !event.contact.email.empty? and event.contact.feedback_notifications? and event.feedback_status.nil? and Product.find_parent(event.product) == "managed_services"
        event.feedback_status = "skipped"
        event.save
      end
    end
  end

  def down
    Event.where( feedback_status: "skipped").each do |event|
      event.feedback_status = nil
      event.save
    end
  end
end
