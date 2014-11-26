desc "Copy location's name into location 2 field if a location currently has location 2 field empty "
task :location_name_as_location_2 => :environment do
  Location.all.each do |loc|
    if loc.building
      address = loc.building.address
      if address and !address.address2.present?
        address.address2 = loc.name
        address.save
      end
    end
  end
end
  