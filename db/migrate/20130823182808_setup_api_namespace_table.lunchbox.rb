# This migration comes from lunchbox (originally 20130820150257)
class SetupApiNamespaceTable < ActiveRecord::Migration
  def change
    create_table :lunchbox_shippings do |t|
      t.string :name
      t.string :shipping_address1
      t.string :shipping_address2
      t.string :shipping_city
      t.string :shipping_state
      t.string :shipping_zip_code

      t.belongs_to :user

      t.timestamps
    end

    create_table :lunchbox_billings do |t|
      t.string :name
      t.string :billing_address1
      t.string :billing_address2
      t.string :billing_city
      t.string :billing_state
      t.string :billing_zip_code

      t.belongs_to :user

      t.timestamps
    end

    create_table :lunchbox_contacts do |t|
      t.string :name
      t.string :phone
      t.string :email

      t.belongs_to :user

      t.timestamps
    end

    create_table :lunchbox_orders do |t|
      t.string :zipcode
      t.string :guest_count
      t.datetime :event_date

      t.text :event_notes

      
      t.belongs_to :lunchbox_billing
      t.belongs_to :lunchbox_shipping
      t.belongs_to :lunchbox_contact

      t.belongs_to :user

      #Snappea stuff
      t.belongs_to :menu_template
      #has_many line_items. 

      #More to come

      t.timestamps
    end
  end
end
