module Fooda
  module Util
    def self.shred_everything!
      return unless Rails.env.development? || Rails.env.test?

      models = Dir.glob("#{ Rails.root }/app/models/*.rb").collect do |file|
        base = File.basename(file)
        base.gsub!('.rb','')

        base.camelize.constantize rescue nil
      end.compact

      models.select! {|m| m.respond_to?(:delete_all) }

      models.each(&:delete_all)
    end

    def self.create_admin_users *emails
      emails.each do |email|
        unless User.find_by_email email
          password = Rails.env.development? ? 'fooda123' : (0...30).map{(65+rand(26)).chr}.join
          user = User.new email: email, 
                          password: password, 
                          first_name: "John", 
                          last_name: "Doe", 
                          created_by: "fooda_rake"
          user.roles = %w[super_admin fooda_employee accounting catering_foodizen foodizen]
          user.skip_confirmation!
          user.skip_reconfirmation!
          user.save!
          puts "Created user: #{user.email} with password #{password}"
        end
      end
    end

    def self.remove_public_users
      unless Rails.env.production? 
        User.all.map{|u| u.destroy if u.email.exclude? "@fooda.com"}
      end
    end

    def self.create_pricing_tiers
      [["Platinium", 5],["Gold",10],["Silver", 20],["Standard", 25]].each do |tier|
        PricingTier.where(name: tier.first, gross_profit: tier.last).first_or_create
      end
    end

    def self.create_markets
      ["Chicago", "New York"].each {|m| Market.find_or_create_by_name(m)}
    end

    def self.create_ssp_persistences
      ["Huddle", "MS Monthly", "GP Catering"].each{|ssp| ssp.find_by_name(ssp).destroy} rescue nil
      SspPersistence.where(:locked => true, :ssp_persistence_type => "managed_services_reports", :name => "Huddle", :parameters => "utf8=&searchable%5Bevent_start_time_from%5D=&searchable%5Bevent_start_time_to%5D=&direction=&sort=&per_page=&searchable%5Bouter_group%5D=Sales+Rep&direction=&sort=&per_page=&searchable%5Bstatus%5D%5B%5D=&searchable%5Bstatus%5D%5B%5D=proposed&searchable%5Bstatus%5D%5B%5D=scheduled&searchable%5Bstatus%5D%5B%5D=active&searchable%5Bstatus%5D%5B%5D=in_progress&searchable%5Bstatus%5D%5B%5D=complete&searchable%5Bstatus%5D%5B%5D=final&searchable%5Bstatus%5D%5B%5D=canceled&direction=&sort=&per_page=&searchable%5Binner_group%5D=Date&direction=&sort=&per_page=&searchable%5Bproduct%5D%5B%5D=&searchable%5Bproduct%5D%5B%5D=catering&direction=&sort=&per_page=&searchable%5Bcol%5D%5B%5D=&searchable%5Bcol%5D%5B%5D=Account&searchable%5Bcol%5D%5B%5D=Date&searchable%5Bcol%5D%5B%5D=Vendors&searchable%5Bcol%5D%5B%5D=Group+Size&searchable%5Bcol%5D%5B%5D=Revenue&searchable%5Bcol%5D%5B%5D=GP&searchable%5Bcol%5D%5B%5D=Status&direction=&sort=&per_page=").first_or_create
      SspPersistence.where(:locked => true, :ssp_persistence_type => "managed_services_reports", :name => "MS Monthly", :parameters => "utf8=&searchable%5Bevent_start_time_from%5D=&searchable%5Bevent_start_time_to%5D=&direction=&sort=&per_page=&searchable%5Bouter_group%5D=Account&direction=&sort=&per_page=&searchable%5Bstatus%5D%5B%5D=&searchable%5Bstatus%5D%5B%5D=proposed&searchable%5Bstatus%5D%5B%5D=scheduled&searchable%5Bstatus%5D%5B%5D=active&searchable%5Bstatus%5D%5B%5D=in_progress&searchable%5Bstatus%5D%5B%5D=complete&searchable%5Bstatus%5D%5B%5D=final&searchable%5Bstatus%5D%5B%5D=canceled&direction=&sort=&per_page=&searchable%5Binner_group%5D=&direction=&sort=&per_page=&searchable%5Bproduct%5D%5B%5D=&searchable%5Bproduct%5D%5B%5D=catering&searchable%5Bproduct%5D%5B%5D=prepaid_popup_gold&searchable%5Bproduct%5D%5B%5D=prepaid_popup_platinum&direction=&sort=&per_page=&searchable%5Bcol%5D%5B%5D=&searchable%5Bcol%5D%5B%5D=Account&searchable%5Bcol%5D%5B%5D=Date&searchable%5Bcol%5D%5B%5D=Event+ID&searchable%5Bcol%5D%5B%5D=Sales+Rep&searchable%5Bcol%5D%5B%5D=Product&searchable%5Bcol%5D%5B%5D=Vendors&searchable%5Bcol%5D%5B%5D=Group+Size&searchable%5Bcol%5D%5B%5D=COGS&searchable%5Bcol%5D%5B%5D=Delivery+Charge&searchable%5Bcol%5D%5B%5D=Subtotal&searchable%5Bcol%5D%5B%5D=Gratuity&searchable%5Bcol%5D%5B%5D=Enterprise+Fee&searchable%5Bcol%5D%5B%5D=Revenue&searchable%5Bcol%5D%5B%5D=Tax&searchable%5Bcol%5D%5B%5D=Total+Billing&searchable%5Bcol%5D%5B%5D=GP&searchable%5Bcol%5D%5B%5D=GP%25&searchable%5Bcol%5D%5B%5D=Status&direction=&sort=&per_page=").first_or_create
      SspPersistence.where(:locked => true, :ssp_persistence_type => "managed_services_reports", :name => "GP Catering", :parameters => "utf8=&searchable%5Bevent_start_time_from%5D=&searchable%5Bevent_start_time_to%5D=&direction=&sort=&per_page=&searchable%5Bouter_group%5D=Sales+Rep&direction=&sort=&per_page=&searchable%5Bstatus%5D%5B%5D=&searchable%5Bstatus%5D%5B%5D=proposed&searchable%5Bstatus%5D%5B%5D=scheduled&searchable%5Bstatus%5D%5B%5D=active&searchable%5Bstatus%5D%5B%5D=in_progress&searchable%5Bstatus%5D%5B%5D=complete&searchable%5Bstatus%5D%5B%5D=final&direction=&sort=&per_page=&searchable%5Binner_group%5D=&direction=&sort=&per_page=&searchable%5Bproduct%5D%5B%5D=&searchable%5Bproduct%5D%5B%5D=catering&direction=&sort=&per_page=&searchable%5Bcol%5D%5B%5D=&searchable%5Bcol%5D%5B%5D=Account&searchable%5Bcol%5D%5B%5D=Date&searchable%5Bcol%5D%5B%5D=Vendors&searchable%5Bcol%5D%5B%5D=Group+Size&searchable%5Bcol%5D%5B%5D=COGS&searchable%5Bcol%5D%5B%5D=Revenue&searchable%5Bcol%5D%5B%5D=GP&searchable%5Bcol%5D%5B%5D=Status&direction=&sort=&per_page=").first_or_create
    end

    def self.create_line_item_types
      LineItemType.where(:line_item_type => "Physical Goods", :line_item_sub_type => "Menu-Item", :sku => "").first_or_create
      LineItemType.where(:line_item_type => "Physical Goods", :line_item_sub_type => "Menu-Fee", :sku => "").first_or_create
      LineItemType.where(:line_item_type => "Physical Goods", :line_item_sub_type => "Equipment", :sku => "999000").first_or_create
      LineItemType.where(:line_item_type => "Physical Goods", :line_item_sub_type => "Other", :sku => "999001").first_or_create

      LineItemType.where(:line_item_type => "Services", :line_item_sub_type => "Site Fee", :sku => "999100").first_or_create
      LineItemType.where(:line_item_type => "Services", :line_item_sub_type => "Management Fee", :sku => "999101").first_or_create
      LineItemType.where(:line_item_type => "Services", :line_item_sub_type => "Enterprise Fee", :sku => "999102").first_or_create
      LineItemType.where(:line_item_type => "Services", :line_item_sub_type => "Gratuity", :sku => "999103").first_or_create
      LineItemType.where(:line_item_type => "Services", :line_item_sub_type => "Delivery Fee", :sku => "999104").first_or_create
      LineItemType.where(:line_item_type => "Services", :line_item_sub_type => "Trash Fee", :sku => "999105").first_or_create
      LineItemType.where(:line_item_type => "Services", :line_item_sub_type => "Other", :sku => "999106").first_or_create
      LineItemType.where(:line_item_type => "Services", :line_item_sub_type => "Service Fee", :sku => "999107").first_or_create

      LineItemType.where(:line_item_type => "Financial", :line_item_sub_type => "Credit Memo", :sku => "999200").first_or_create
      LineItemType.where(:line_item_type => "Financial", :line_item_sub_type => "Voucher", :sku => "999201").first_or_create
      LineItemType.where(:line_item_type => "Financial", :line_item_sub_type => "Subsidy", :sku => "999202").first_or_create
      LineItemType.where(:line_item_type => "Financial", :line_item_sub_type => "Non Sufficient Funds Fee", :sku => "999203").first_or_create
      LineItemType.where(:line_item_type => "Financial", :line_item_sub_type => "Other", :sku => "999204").first_or_create

      LineItemType.where(:line_item_type => "Tax", :line_item_sub_type => "Water Bottle Tax", :sku => "999300").first_or_create
      LineItemType.where(:line_item_type => "Tax", :line_item_sub_type => "Other", :sku => "999301").first_or_create

      LineItemType.where(:line_item_type => "Other", :line_item_sub_type => "Other", :sku => "999400").first_or_create
    end

    def self.create_account
      account = Account.where(name: "ACME", account_type: "residential").first_or_create
      building = Building.where(name: "1 Main St.", market_id: Market.first.id ,timezone: "Central Time (US & Canada)").first_or_create
      Location.where(name: "ACME Kitchen", account_id: account.id, building_id: building.id).first_or_create
    end

    def self.populate_catering_order_tax_column
      require "catering/order_builder"

      puts "Event\t Order\tTax (dump)\tTax (calc)\tAction"
      puts "-----\t -----\t----------\t----------\t------"

      no_associated_event = 0;

      # Loop through all orders
      Catering::Order.order(:id).all.each do |order|

        # Run this only if an associated event exists
        # (a few orders may not have associated events because of issues occurring on production)
        unless order.event.nil?

          # Run this task only if the tax column is not available
          if order.tax.nil? or order.tax == 0

            order_builder = Catering::OrderBuilder.new(order).dump()

            # We require the order builder dump since it is the master data
            unless order.order_builder_dump.nil?
              # Assume we're going to be vocal about setting the tax for this row,
              # we'll populate it with the tax value from the order builder dump var
              complain = true

              # Fetch required data from dump & through rebuild routine
              builder_dump = order.order_builder_dump.symbolize_keys
              tax_amount = builder_dump[:tax_amount]["fractional"].to_i
              diff = (tax_amount - order_builder[:tax_amount].fractional.to_i)

              # Don't complain about this row if tax amount is exact (or off by 1 cent / rounding)
              if (diff == 0) or (diff == 1) or (diff == -1)
                complain = false
              end

              # Populate the tax column from the tax_amount read from the order builder dump var
              order.tax = tax_amount
              order.save

              puts order.event.pretty_id.to_s + "\t " + order.id.to_s + "\t" + tax_amount.to_s + "\t\t" + order_builder[:tax_amount].fractional.to_i.to_s + "\t\t" + (complain ?  "tax mismatch: overridden using order_builder_dump("+tax_amount.to_s+")" : "populated ("+tax_amount.to_s+")")
            else
              # No order builder dump available as master data, skip this row
              puts order.event.pretty_id.to_s + "\t " + order.id.to_s + "\tNot Available\t" + order_builder[:tax_amount].fractional.to_i.to_s + "\t\t" + "no action: order_builder_dump not available"
            end

          else
            # Tax column already populated, skip this row
            puts order.event.pretty_id.to_s + "\t " + order.id.to_s + "\t--\t\t"+order.tax.to_s+"\t\tno action: tax already populated"
          end

        else
          # Event wasn't created for this order
          puts "*      \t " + order.id.to_s + "\t\t\t\t\tno action: no associated event!"
          no_associated_event = no_associated_event + 1
        end # order has an associated event
      end # all orders each do

      if no_associated_event > 0
        puts "\n"
        puts "* There is no associated event for this order.\n  This means that the order is in a FUBARed state.\n  Delete the order row and associated data from the database."
      end
    end
    def self.create_god_user
        u = User.where(email: "foodadev@fooda.com").first_or_initialize
        u.first_name =  "System"
        u.last_name = "User"
        u.utility_account = true
        u.password= "iloverandompasswordsbutthisonewilldo"
        u.save!
        u.confirm!
    end
  end
end
