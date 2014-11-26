# Configuration settings for the Heroku Development App: snappea-dev
# It should have the git remote: dev

SnapPea::Application.configure do
  config.catering_subdomain = ENV["CATERING_SUBDOMAIN"] or "catering-experimental"

  config.lograge.enabled = true
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
#  config.force_ssl = true

  # See everything in the log (default is :info)
  config.log_level = :warn

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  if File.exists?(Rails.root.join('config/memcached.yml'))
    memcached_config = YAML.load_file(Rails.root.join('config/memcached.yml'))
    memcached_host = memcached_config[Rails.env]['host'] + ':' + memcached_config[Rails.env]['port'].to_s
    config.cache_store = :dalli_store, memcached_host
  else
    config.cache_store = :dalli_store
  end

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( snappea.css )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  config.action_mailer.default_url_options = { :host => 'snappea-experimental.herokuapp.com' }

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address => 'mailtrap.io',
    :port => 2525,
    :authentication => :plain,
    :user_name => "mailtrap-snappea-experimental-69e041635188535f",
    :password => "0337387f44855759"
  }
end
