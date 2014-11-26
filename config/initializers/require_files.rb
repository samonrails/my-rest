Dir[Rails.root + 'lib/fooda/*.rb'].each { |file| require file }
Dir[Rails.root + 'lib/external/*.rb'].each { |file| require file }

