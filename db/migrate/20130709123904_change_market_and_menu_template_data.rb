class ChangeMarketAndMenuTemplateData < ActiveRecord::Migration
  def up

    # Set all current markets to Chicago
    Vendor.all.map{|v| v.market_list = "Chicago"; v.save }

    # Set the one New York Vendor to the New York market
    Vendor.where(:name => "Agave Restaurant & Tequila Bar").map{|v| v.market_list = "New York"; v.save }

    # Create "A La Carte" menu templates for vendors which do not yet have them.
    Vendor.select{|v| v.menu_templates.where(:name => 'A La Carte', :product_type => 'managed_services').count == 0}.each { |v| v.create_all_item_menu_templates}

    # Make sure that all "A La Carte" menu templates are "All Items" menu templates
    MenuTemplate.where(:name => 'A La Carte').map{|mt| mt.all_items = true; mt.save}

    # Run all inventory items through the "All Items" menu templates so that they are added if necessary.
    MenuTemplate.where(:all_items => true).each {|mt| mt.vendor.inventory_items.each{|i| mt.inventory_item_updated(i)}}
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Can't undo markets, menu templates."
  end
end
