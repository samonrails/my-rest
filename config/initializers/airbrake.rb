if Rails.env.production? || Rails.env.staging?
  Airbrake.configure do |config|
    config.api_key = '99dae923ca84462ccfc6f86c46cd85b6'
  end
end
