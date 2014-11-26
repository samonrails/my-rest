require 'simplecov'
SimpleCov.start

ENV["RAILS_ENV"] = 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'webrick/https'
require 'rack/handler/webrick'
require 'fake_braintree'
require 'sidekiq/testing'
require "cancan/matchers"

Sidekiq::Testing.fake!

include Devise::TestHelpers

Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.before do
    FakeBraintree.clear!
  end

  config.include FactoryGirl::Syntax::Methods

  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end

  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
  config.include(MailerMacros)
  config.include AssertDifference
  config.before(:each) { reset_emails }
end

ActiveRecord::ConnectionAdapters::ConnectionPool.class_eval do
  def current_connection_id
    Thread.main.object_id
  end
end

def sign_in_user(user=nil)
  @user = user || FactoryGirl.create(:user)
  @user.confirm!
  sign_in @user
end

def expect_redirect_to(path)
  expect(response).to redirect_to path
end

def expect_response_code(rcode)
  expect(response.status).to eq rcode
end

def expect_success_message(message)
  expect(flash[:notice]).to eq message
end

def expect_error_message(message)
  expect(flash[:error]).to eq message
end

def expect_alert_message(message)
  expect(flash[:alert]).to eq message
end
