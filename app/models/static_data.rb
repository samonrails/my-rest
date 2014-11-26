module StaticData
  Cuisines              = IO.read(File.join(Rails.root,'db','lists','cuisines.txt')).lines.to_a.map(&:strip).sort
  Buildings             = Building.where("insurance_required = '#{true}'").map{|a| a.name}
  InventoryTags         = IO.read(File.join(Rails.root,'db','lists','inventory_tags.txt')).lines.to_a.map(&:strip).sort
  DietaryRestrictions   = IO.read(File.join(Rails.root,'db','lists','dietary_restrictions.txt')).lines.to_a.map(&:strip).sort
end