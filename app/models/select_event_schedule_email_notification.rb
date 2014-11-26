# == Schema Information
#
# Table name: select_event_schedule_email_notifications
#
#  select_event_schedule_id :integer
#  list_id                  :string(255)
#  introduction_email_time  :time
#  final_email_time         :time
#

class SelectEventScheduleEmailNotification < ApplicationModel
  belongs_to :select_event_schedule

  validates_presence_of :select_event_schedule_id
  validates_presence_of :list_id
  
  belongs_to :created_by, :class_name => "User"

end

