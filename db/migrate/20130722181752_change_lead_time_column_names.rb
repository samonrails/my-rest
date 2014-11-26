class ChangeLeadTimeColumnNames < ActiveRecord::Migration
  def change
    rename_column :vendors, :lead_time_for_150_above_people, :lead_time_for_150_300_people
    rename_column :vendors, :lead_time_for_max, :lead_time_for_300_above_people
  end
end