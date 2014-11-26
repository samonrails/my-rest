Sidekiq.configure_server do |config|
  redis_url = ENV['REDIS_URL']
  raise "define environment varialbe REDIS_URL" if redis_url.nil? or redis_url.empty? 
  config.redis = { url: "#{redis_url}", namespace: "snappea_#{Rails.env}" }
end

Sidekiq.configure_client do |config|
  redis_url = ENV['REDIS_URL']  
  raise "define environment varialbe REDIS_URL(#{redis_url})" if redis_url.nil? or redis_url.empty? 
  config.redis = { url: "#{redis_url}" , namespace: "snappea_#{Rails.env}" }
end
