Sidetiq.configure do |config|
  # When `true` uses UTC instead of local times (default: false).
  config.utc = true
end

# Require all existing scheduled jobs
Dir[Rails.root.join "app/workers/**/*.rb"].each { |f| require f }
