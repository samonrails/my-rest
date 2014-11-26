require 'analytics-ruby'
worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)
timeout 45
preload_app true

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end 

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection

  if defined? AnalyticsRuby 
    Analytics = AnalyticsRuby          # Alias for convenience
    Analytics.init({
      secret: ENV["SEGMENT_IO_SECRET"] || '',  # The secret for Fooda
      on_error: Proc.new { |status, msg| print msg }  # Optional error handler
    })
  end
end