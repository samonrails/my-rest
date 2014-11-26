class UpdateMenuTemplateAveragePrice < ActiveRecord::Migration
  def up
    #Taken from add_capacity_fiels.rb migration
    # Sometimes this fails on a migration run and I'm not sure why. -djb
    # Moved to Deploy notes instead
    # MenuTemplate.all.map(&:update_average_per_person_price)
  end

  def down
  end
end
