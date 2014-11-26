class AddSiteOptionsSelectEventSchedules < ActiveRecord::Migration
  def up
    add_column :select_event_schedules, :hide_gratuity_from_site, :boolean, :default => false
    add_column :select_event_schedules, :hide_delivery_fee_from_site, :boolean, :default => false
    add_column :select_event_schedules, :hide_tax_from_site, :boolean, :default => false
    add_column :select_event_schedules, :fixed_amount_cents, :integer
  end

  def down
  end
end
