class AddListIdToSelectEventCampaigns < ActiveRecord::Migration
  def change
    add_column :select_event_campaigns, :email_list_id, :string
  end
end
