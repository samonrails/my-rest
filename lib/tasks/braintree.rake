
# Don't forget to purge the braintree sandbox as well. 
desc "Purge the braintree data in our postgres db"
task :purge_braintree_accounts => :environment do
  unless Rails.env.production?
    Card.destroy_all
    User.all.map {|u|u.default_billing_id = nil; u.save}
  end
end

desc "Create braintree accounts for users without them"
task :create_braintree_accounts => :environment do
  unless Rails.env.production?
    User.all.each { |user| user.build_braintree_account.save }
  end
end
  