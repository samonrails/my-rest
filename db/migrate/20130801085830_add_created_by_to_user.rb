class AddCreatedByToUser < ActiveRecord::Migration
  def change
    add_column :users, :created_by, :string
  end
end
