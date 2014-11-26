class CreateSelectEventScheduleBillingReferences < ActiveRecord::Migration
  def up
    create_table :select_event_schedule_billing_references, :id => false do |t|
  		t.belongs_to :select_event_schedule
  		t.belongs_to :billing_reference
  	end
  	
  	add_index :select_event_schedule_billing_references, [:select_event_schedule_id, :billing_reference_id] , :unique => true, :name => "select_event_schedule_billing_references_select_billing"
  end

  def down
  end
end
