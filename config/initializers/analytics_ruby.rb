Analytics = AnalyticsRuby            # Alias for convenience
Analytics.init({
    secret: ENV["SEGMENT_IO_SECRET"] || '',  # The secret for Fooda
    on_error: Proc.new { |status, msg| print msg }  # Optional error handler
})