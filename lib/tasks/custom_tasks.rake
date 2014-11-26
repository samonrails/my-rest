require 'fooda/util'

namespace :db do
  desc "Annotates our models with the db schema"
  task :annotate do
    `bundle exec annotate --position=before`
  end

  task :shred_everything => :environment do
    Fooda::Util.shred_everything!
  end

  desc "Given an [email], create a super admin with password fooda123."
  task :add_admin_user, [:email] => :environment do |t, args|
    Fooda::Util.create_admin_users args[:email]
  end

  desc "soft delete all users without a fooda email address"
  task :remove_public_users => :environment do |t, args|
    Fooda::Util.remove_public_users
  end  

  desc "Populate tax column in catering_orders from order_builder_dump."
  task :populate_catering_order_tax_column => :environment do
    Fooda::Util.populate_catering_order_tax_column
  end
end

Rake::Task["db:migrate"].enhance do
  Rake::Task["db:annotate"].invoke
end
