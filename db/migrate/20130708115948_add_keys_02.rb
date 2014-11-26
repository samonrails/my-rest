class AddKeys02 < ActiveRecord::Migration
  def change
    add_foreign_key "accounts", "users", :name => "accounts_account_exec_id_fk", :column => "account_exec_id"
    add_foreign_key "accounts", "users", :name => "accounts_account_manager_id_fk", :column => "account_manager_id"
    add_foreign_key "comments", "issues", :name => "comments_issue_id_fk"
    add_foreign_key "comments", "users", :name => "comments_user_id_fk"
    add_foreign_key "event_schedules", "accounts", :name => "event_schedules_account_id_fk"
    add_foreign_key "event_schedules", "contacts", :name => "event_schedules_contact_id_fk"
    add_foreign_key "event_schedules", "users", :name => "event_schedules_created_by_id_fk", :column => "created_by_id"
    add_foreign_key "event_schedules", "locations", :name => "event_schedules_location_id_fk"
    add_foreign_key "event_schedules", "menu_templates", :name => "event_schedules_menu_template_id_fk"
    add_foreign_key "event_schedules", "vendors", :name => "event_schedules_vendor_id_fk"
    add_foreign_key "events", "event_managed_services_rollups", :name => "events_event_managed_services_rollup_id_fk"
    add_foreign_key "events", "event_schedules", :name => "events_event_schedule_id_fk"
    add_foreign_key "issues", "users", :name => "issues_assignee_id_fk", :column => "assignee_id"
    add_foreign_key "issues", "users", :name => "issues_assigner_id_fk", :column => "assigner_id"
    add_foreign_key "line_items", "menu_templates", :name => "line_items_menu_template_id_fk"
  end
end
