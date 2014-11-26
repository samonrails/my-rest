# == Schema Information
#
# Table name: select_event_billing_references
#
#  select_event_id      :integer
#  billing_reference_id :integer
#

class SelectEventBillingReference < ActiveRecord::Base
  belongs_to :billing_reference
  belongs_to :select_event
  validates_presence_of :select_event
  validates_presence_of :billing_reference
  
end
