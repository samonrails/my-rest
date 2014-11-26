desc "Approve all the current buildings in the system"
task :approve_current_buildings => :environment do
  Building.all.each do |building|
    building.approve!
  end
end
  