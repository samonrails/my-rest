class AddWebIdAndUserIdToSelectEventCampaigns < ActiveRecord::Migration
  def change
    add_column :select_event_campaigns, :created_by_id, :integer
    add_column :select_event_campaigns, :campaign_web_id, :integer
  end
end
