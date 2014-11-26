class CreateSelectEventCampaigns < ActiveRecord::Migration
  def change
  	create_table :select_event_campaigns do |t|
  		t.belongs_to 	:select_event
  		t.string		:state
  		t.string    :email_type
  		t.timestamps
  	end

  	add_column :select_events, :introduction_email_campaign_id, :integer
  	add_column :select_events, :final_email_campaign_id, :integer

  end
  
end
