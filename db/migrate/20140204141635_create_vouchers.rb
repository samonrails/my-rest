class CreateVouchers < ActiveRecord::Migration
  def up
    create_table :voucher_templates do |t|
      t.string :name
      t.text :description
      t.integer :cogs_cents
      t.string :line_item_sku

      t.timestamps
    end

    create_table :voucher_groups do |t|
      t.string :name
      t.text :description
      t.integer :cogs_cents
      t.integer :quantity

      t.belongs_to :event
      t.belongs_to :order
      t.belongs_to :line_item
      t.belongs_to :voucher_template
      t.integer :purcashed_by_id

      t.timestamps
    end

    create_table :vouchers do |t|
      t.belongs_to :voucher_group
      t.string :token
    end

    VoucherTemplate.create(:name => "$8.00 Meal Voucher", 
                           :description => "Redeem at a Fooda Popup for up to $8.00.",
                           :cogs_cents => 800,
                           :line_item_sku => "999201" )
    VoucherTemplate.create(:name => "$10.00 Meal Voucher", 
                           :description => "Redeem at a Fooda Popup for up to $10.00.",
                           :cogs_cents => 1000,
                           :line_item_sku => "999201" )
    VoucherTemplate.create(:name => "$12.00 Meal Voucher", 
                           :description => "Redeem at a Fooda Popup for up to $12.00.",
                           :cogs_cents => 1200,
                           :line_item_sku => "999201" )

    LineItemType.create!(:line_item_type => "Services", :line_item_sub_type => "Service Fee", :sku => "999107")
  end

  def down
    drop_table :voucher_templates
    drop_table :voucher_groups
    drop_table :vouchers
    LineItemType.find_by_sku("999107").destroy
  end
end
