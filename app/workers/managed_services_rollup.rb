class ManagedServicesRollup
  include Sidekiq::Worker

  def perform(event_id)
    Event.find(event_id).do_managed_services_rollup
  end
end
