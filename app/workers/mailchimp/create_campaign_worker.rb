class Mailchimp::CreateCampaignWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :default, :retry => 3

  sidekiq_retries_exhausted do |msg|
    # send email here 
    Sidekiq.logger.warn "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
  end

  def perform select_event_properties, options={}
    gibbon = Mailchimp.gibbon_api
    mailchimp_response = gibbon.campaigns.create options
    # Update the select event with this
    
    select_event = SelectEvent.find(select_event_properties['id'])
    if select_event
      select_event.worker_create_campaign select_event_properties, mailchimp_response

     
    end
  end
end
