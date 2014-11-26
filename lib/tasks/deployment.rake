# Commented out for safety but left for reference. -DJB.


namespace :deployment do

#   desc "Default market tax, default Chicago market on buildings, force event managed service rollup."
#   task "1.2.0" => :environment do
#     # Default Market tax rate
#     Market.all.map{|m| m.default_tax_rate = 10.25; m.save}

#     #If buildings don't have a market. 
#     Building.where(:market_id => nil).map {|a| a.market = Market.first; a.save}

#     #Force a global event rollup
#     Event.all.map{ |e| e.do_managed_services_rollup }
#   end

  desc "update the braintree id for accounts before the switch."
  task :populate_braintree_ids => :environment do
    User.all.map do |u|
      if u.braintree_identity.nil?
        u.braintree_account.braintree_id = u.braintree_account.id
        u.braintree_account.save
        puts "User (#{u.email} updated braintree id."
      else
        puts "Did not update (#{u.email}) braintree account. ID already exists: (#{u.braintree_identity})"
      end
    end
  end


  desc "Update all vendor yelp scores then print any without a score"
  task :force_yelp_roll_up => :environment do
    Sidekiq::Client.enqueue(WeeklyVendorUpdate)
  end

  desc "Move all event documents into a nice directory. Fail safe."
  task :organize_s3_event_document_directory => :environment do

    Document.all.each do |d|
      if d.full_file_name 
        if !d.full_file_name.include? "event_document"
          d.full_file_name.insert(0, "event_documents/")
          d.save
          puts "renamed file in Snappea to: #{d.full_file_name}"
        elsif !d.full_file_name.include? "vendor_billing" 
          d.full_file_name.insert(0, "vendor_billing_summaries/")
          d.save
          puts "renamed file in Snappea to: #{d.full_file_name}"
        else
          puts "No Snappea Action"
        end
      end
    end

    AWS::S3::Base.establish_connection! access_key_id: AWS::Key, secret_access_key: AWS::Secret

    private_bucket = AWS::S3::Bucket.find AWS::PrivateBucket 
    private_bucket.objects.each do |object| 
      if object.key.index(/(Packing|Packaging|Purcahse|Quote|Invoice)/)
        puts "#{object.key}: renamed in AWS to: event_documents/#{object.key}"
        AWS::S3::S3Object.rename object.key, "event_documents/#{object.key}", AWS::PrivateBucket
      elsif object.key.index(/Vendor-Billing-Summary/)
        puts "#{object.key}: renamed in AWS to: vendor_billing_summaries/#{object.key}"
        AWS::S3::S3Object.rename object.key, "vendor_billing_summaries/#{object.key}", AWS::PrivateBucket
      else
        puts "#{object.key}: No AWS Action"
      end
    end

    puts '***'
    puts 'Please do the rest by hand in the Rails Console & 3Hub'
  end

end
