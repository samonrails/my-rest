# == Schema Information
#
# Table name: select_event_campaigns
#
#  id               :integer          not null, primary key
#  select_event_id  :integer
#  state            :string(255)
#  email_type       :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  campaign_id      :string(255)
#  created_by_id    :integer
#  campaign_web_id  :integer
#  email_list_id    :string(255)
#  scheduled_at     :datetime
#  scheduled_at_utc :datetime
#


class SelectEventCampaign < ActiveRecord::Base

	belongs_to :select_event
  has_many :select_events
  belongs_to :created_by, :class_name => "User"
 


end
