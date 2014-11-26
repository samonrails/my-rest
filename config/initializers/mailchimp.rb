class MailChimp

  DEFAULT_TZ='Central Time (US & Canada)'
  Time::DATE_FORMATS[:mailchimp_datetime_format] = "%Y-%m-%d %H:%M:%S"
  EDIT_CAMPAIGN_URL='https://us3.admin.mailchimp.com/campaigns/wizard/confirm?id='
  VIEW_CAMPAIGN_URL='https://us3.admin.mailchimp.com/campaigns/preview?id='
end
