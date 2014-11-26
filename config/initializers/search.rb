begin
  Fooda::Search.configure :models => [Account, Event, Vendor]
rescue => e
  raise(e) unless $rake_task
end
