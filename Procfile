# Heroku uses this to start an environment

web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb

worker: bundle exec sidekiq --config ./config/sidekiq.yml
