class Setup < ActiveRecord::Migration
  def up
    create_table :accounts do |t|
      t.string  :name

      t.timestamps
    end

    create_table :pricing_tiers do |t|
      t.string  :name
      t.decimal :percent_above_cost

      t.timestamps
    end

    create_table :account_pricing_tiers do |t|
      t.string :product
      t.belongs_to :account
      t.belongs_to :pricing_tier

      t.timestamps
    end

    create_table :product_types do |t|
      t.string  :name
      t.timestamps
    end

    create_table :products, :force => true do |t|
      t.string  :name

      t.belongs_to  :product_type
      t.timestamps
    end

    create_table :vendors do |t|
      t.string :name
      t.string :legal_name
      t.string :description
      t.string :logo
      t.string :website

      t.timestamps
    end

    create_table :vendor_product_types, :id => false do |t|
      t.belongs_to :vendor
      t.belongs_to :product_type
      t.string :status
    end

    create_table :inventory_items do |t|
      t.string      :name
      t.string      :description
      t.decimal     :buy_price
      t.decimal     :retail_price
      t.string      :sku
      t.boolean     :featured
      t.string      :type
      t.string      :image

      t.belongs_to  :vendor
      t.timestamps
    end

    create_table :vendor_products, :id => false do |t|
      t.belongs_to :vendor
      t.belongs_to :product
    end

    create_table :options do |t|
      t.string :name

      t.belongs_to :inventory_item
      t.timestamps
    end

    create_table :menu_templates do |t|
      t.string        :name
      t.string       :menu_pricing 
      t.date         :expiration_date, :null => true
      t.date         :start_date, :null => false

      t.belongs_to    :product
      t.belongs_to    :vendor
      t.timestamps
    end

    create_table :events do |t|
      t.string :name
			t.date :event_date
			t.string :event_time
			t.string :meal_type
      t.belongs_to :vendor
      t.belongs_to :account
      t.belongs_to :menu
      t.timestamps
    end

    create_table :menus do |t|
      t.string :name

      t.decimal :sell_price

      t.timestamps
    end

    create_table :menu_items do |t|
      t.decimal :sell_price
      t.boolean :featured

      t.belongs_to :menu
      t.belongs_to :inventory_item

      t.timestamps
    end
 end

  def down
    drop_table :vendors
    drop_table :product_types
    drop_table :vendor_product_types
    drop_table :accounts
    drop_table :products
    drop_table :vendor_products
    drop_table :events

    drop_table :menus
    drop_table :menu_items
    drop_table :inventory_items
    drop_table :menu_templates
    drop_table :pricing_tiers
    
    drop_table :options

  end
end










