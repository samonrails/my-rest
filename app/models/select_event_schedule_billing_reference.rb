# == Schema Information
#
# Table name: select_event_schedule_billing_references
#
#  select_event_schedule_id :integer
#  billing_reference_id     :integer
#

class SelectEventScheduleBillingReference < ActiveRecord::Base
  belongs_to :billing_reference
  belongs_to :select_event_schedule
  
  validates_presence_of :select_event_schedule
  validates_presence_of :billing_reference
  
end
