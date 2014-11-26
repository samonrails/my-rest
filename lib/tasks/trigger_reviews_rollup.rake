# Triggering reviews rollups for existing accounts and vendors

task :trigger_reviews_rollup => :environment do
  Vendor.all.each{|v| v.trigger_reviews_rollup}
  Account.all.each{|a| a.trigger_reviews_rollup}
end