namespace :elasticsearch do
  desc "Create relevant indexes for ElasticSearch"
  task :create_indexes => :environment do
    Event.reindex
    SelectEvent.reindex
  end

end
