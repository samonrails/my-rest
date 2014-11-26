desc "Copy data points from the check box version of meal periods to the original ActsAsTaggable input."
task :copy_meal_period_data => :environment do
  MenuTemplate.all.each do |menu|
    menu.meal_period_list = menu.meal_period
    menu.save
  end
end
  