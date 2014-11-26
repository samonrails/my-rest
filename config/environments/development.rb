# Configuration settings for your local machine in development.

SnapPea::Application.configure do
  config.catering_subdomain = ENV["CATERING_SUBDOMAIN"] or "catering"

  # If your running unicon turn this on for logs
  # config.lograge.enabled = false
  
  config.enable_code_sync_manager = true
  config.enable_code_sync_server = true

  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # See everything in the log (default is :info)
  config.log_level = :debug

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = true
  
  # Memcache
  config.cache_store = :memory_store

  # I care if the the mailer can't send
  config.action_mailer.raise_delivery_errors = true

  # Compile my assets for emails
  config.action_mailer.asset_host = "http://localhost:3000"

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  # Enable threaded mode
  # config.threadsafe!

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address => 'mailtrap.io',
    :port => 2525,
    :authentication => :plain,
    :user_name => "mailtrap-snappea-development-f97999a9a60bd768",
    :password => "ad30bc1548b27328"
  }
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  default_url_options[:host => "localhost:3000"]
end
