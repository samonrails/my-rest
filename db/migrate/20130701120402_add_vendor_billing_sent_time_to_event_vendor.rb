class AddVendorBillingSentTimeToEventVendor < ActiveRecord::Migration
  def change
    add_column :event_vendors, :vendor_billing_summary_sent_at, :datetime
  end
end
