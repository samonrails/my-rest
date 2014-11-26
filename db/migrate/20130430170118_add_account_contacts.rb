class AddAccountContacts < ActiveRecord::Migration
  def up
    create_table :contacts do |t|
      t.string  :name
      t.string  :position
      t.string  :email
      t.string  :phone_number
      t.string  :mobile_number 
      t.string  :fax_number 
      t.boolean :primary_contact
      t.boolean :billing_notifications  
      t.boolean :event_notifications  
      t.boolean :sms

      t.belongs_to :account

      t.timestamps
    end    
  end

  def down
    drop_table :contacts
  end
end
