class UpdateVendorDescriptionField < ActiveRecord::Migration
  def up
    change_column :vendors, :description, :text
  end

  def down
    change_column :vendors, :description, :string
  end
end
