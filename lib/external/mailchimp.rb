module Mailchimp

  def self.subscribe_email list_id, email
    Mailchimp::SubscribeEmailWorker.perform_async({id: list_id, email: {email: email}})
  end

  # TODO expand this to the html slug: http://apidocs.mailchimp.com/api/rtfm/campaigncreate.func.php
  # {type: type, content: { text: }, options: { :list_id, :subject, :from_email, :from_name, :to_name }}
  def self.create_campaign select_event_properties, options
    Mailchimp::CreateCampaignWorker.perform_async(select_event_properties, options)
  end

  # options: { :list_id, :subject, :from_email, :from_name, :to_name }
  def self.create_plaintext_campaign text, select_event_properties, options={}
    options_for_api = { type: "plaintext", content: { text: text }, options: options}
    Mailchimp::CreateCampaignWorker.perform_async(select_event_properties, options_for_api )
  end

  def self.schedule_campaign options={}
    Mailchimp::ScheduleCampaignWorker.perform_async(options)
  end

  def self.pause_campaign campaign_id
    Mailchimp::PauseCampaignWorker.perform_async({cid: campaign_id})
  end

  def self.unschedule_campaign campaign_id
    Mailchimp::UnscheduleCampaignWorker.perform_async({cid: campaign_id})
  end

  def self.send_campaign campaign_id
    Mailchimp::SendCampaignWorker.perform_async({cid: campaign_id})
  end
  
  def self.convert_time client_time_zone, date_time_for_campaign
    
    introduction_email_time = ActiveSupport::TimeZone[ client_time_zone ].parse(date_time_for_campaign).utc
    #introduction_email_time_for_mailchimp = introduction_email_time.in_time_zone( Mailchimp::DEFAULT_TZ )
    introduction_email_time_for_mailchimp = introduction_email_time.to_s(:mailchimp_datetime_format)
    
  end
  
  def self.gibbon_api 
    mailchimp_api_key = ENV['MAILCHIMP_API_KEY']
    raise "define environment varialbe MAILCHIMP_API_KEY" if mailchimp_api_key.nil? or mailchimp_api_key.empty? 
    Gibbon::API.new mailchimp_api_key
  end
end
