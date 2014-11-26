# == Schema Information
#
# Table name: select_event_schedule_vendors
#
#  id                       :integer          not null, primary key
#  account_id               :integer
#  select_event_schedule_id :integer
#  vendor_id                :integer
#  menu_template_id         :integer
#


class SelectEventScheduleVendor < ApplicationModel

  belongs_to :vendor
  belongs_to :menu_template
  
  
end
