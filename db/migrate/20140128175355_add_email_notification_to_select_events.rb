class AddEmailNotificationToSelectEvents < ActiveRecord::Migration
  def change
    add_column :select_events, :email_list_id, :string
    add_column :select_events, :introduction_email_time, :datetime 
    add_column :select_events, :final_email_time, :datetime 
  end
end
