class AddRequiredToOptionGroups < ActiveRecord::Migration
  def change
    add_column :option_groups, :required, :integer
  end
end
