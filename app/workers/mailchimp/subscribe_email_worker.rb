class Mailchimp::SubscribeEmailWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :default

  sidekiq_retries_exhausted do |msg|
    Sidekiq.logger.warn "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
  end

  def perform options={}
    gibbon = Mailchimp.gibbon_api
    gibbon.lists.subscribe options 
  end
end
