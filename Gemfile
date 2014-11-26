source 'https://rubygems.org'

ruby "2.1.0"
gem 'rails', '3.2.17'


#In House Gems
#gem 'catering', git: "https://748e50427d1a0e3611dc56b66e73d570fe22e26e:x-oauth-basic@github.com/Fooda/catering.git", :tag => 'v2.40.0-alpha1'
gem 'catering', path: "../catering"

# Core Gems
gem 'acts-as-taggable-on'
gem 'analytics-ruby', '<1.0'
gem 'strong_parameters'
gem 'draper', '~> 1.0'
gem 'country_select'
gem 'simple_form'
gem 'paperclip'
gem 'fog'
gem 'money-rails'
gem 'kaminari'
gem 'coffee-rails', '~> 3.2.1'
gem 'ice_cube', '~> 0.11.3'
gem 'date_validator'
gem 'chronic'
gem 'lograge'
gem 'quiet_assets'
gem 'geocoder'
gem 'braintree'
gem 'activerecord-reputation-system'
gem 'unicorn'
gem 'grape'
gem "switch_user"
gem 'le'
gem 'sinatra', '>= 1.3.0', :require => nil
gem 'hashids'
gem 'annotate', ">=2.5.0"
gem "aws-s3"
gem 'gibbon'


# Front-End Gems
gem 'haml'
gem 'sass'
gem 'doc_raptor'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-cookie-rails'
gem 'font-awesome-rails'
gem 'bootstrap-sass-rails'
gem 'select2-rails'
gem 'bootstrap-kaminari-views'
gem 'formtastic'
gem 'recurring_select'
gem 'backbone-on-rails'
gem "highcharts-rails", "~> 3.0.0"
gem 'gmapsjs'

# Database Gems
gem 'pg'
gem 'sidekiq', '~> 2.17.0'
gem 'sidetiq', '~> 0.5.0'
gem 'paranoia'
gem 'responders'
gem 'foreigner'
gem 'immigrant'
gem "rails-settings-cached", "0.2.4"

# Caching
gem 'dalli'
gem 'memcachier'

# Security
gem "devise"
gem 'devise_invitable'
gem 'cancan'
gem "figaro"
gem 'oauth'

# Search
gem 'searchkick', "0.5.2"


group :production, :staging do
  # Monitoring
  gem 'newrelic_rpm'
  gem 'airbrake'
end

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'uglifier',     '>= 1.0.3'
  gem 'jquery-fileupload-rails'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'ffaker'
  gem 'assert_difference'
end

group :development do
  gem "html2haml"
  gem 'meta_request'
  # These cause ruby-1.9.3 to randomly seg fault. -djb
  # gem 'better_errors'
  # gem 'binding_of_caller'
  gem "spring"
  gem "spring-commands-rspec"
  gem 'benchprep_tagster', git: 'git://github.com/watermelonexpress/benchprep-tagster.git'
end

group :test do
  gem "codeclimate-test-reporter", require: nil
  gem 'fake_braintree'
end

group :test, :development do
  gem 'delorean'
  gem 'rspec-rails'
  gem 'capybara', '>= 2.0'
  gem 'shoulda'
  gem 'rb-inotify', :require => false
  gem 'rb-fsevent', :require => false
  gem 'rb-fchange', :require => false
  gem 'selenium-webdriver'
  gem 'simplecov', :require => false, :group => :test
  gem 'coveralls', require: false
  gem 'pry'
  gem 'pry-remote'
  gem 'pry-nav'
  gem 'railroady'
  gem 'zeus', require: false
end

