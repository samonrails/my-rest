class AddCampaignIdToSelectEventCampaigns < ActiveRecord::Migration
  def change
    add_column :select_event_campaigns, :campaign_id, :string
  end
end
