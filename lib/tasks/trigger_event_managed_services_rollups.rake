# Triggering reviews rollups for existing events

task :trigger_event_managed_services_rollups => :environment do
  Event.find_each do |event|
    event.event_managed_services_rollup.update_attributes(delivery_charge_to_account: event.catering_delivery_charge_to_account) if event.event_managed_services_rollup
  end
end
