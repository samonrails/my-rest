desc "Changing line_item_sub_type from 'Service Fee' to 'Delivery Fee'"
task :service_fee_to_delivery_fee => :environment do
  puts "Events affected are:"
  LineItem.find_each do |li|
    if li.line_item_sub_type == "Service Fee"
      li.update_attribute("line_item_sub_type", "Delivery Fee")
      puts li.event.try(:pretty_id)
    end
  end
end