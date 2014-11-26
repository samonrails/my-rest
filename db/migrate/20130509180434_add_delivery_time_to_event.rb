class AddDeliveryTimeToEvent < ActiveRecord::Migration
  def change
    add_column :events, :deliver_time, :string
  end
end
