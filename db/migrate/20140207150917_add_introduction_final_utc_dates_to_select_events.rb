class AddIntroductionFinalUtcDatesToSelectEvents < ActiveRecord::Migration
  def change
    add_column :select_events, :introduction_email_time_utc, :datetime
    add_column :select_events, :final_email_time_utc, :datetime
  end
end
