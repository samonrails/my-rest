class ChangePaymentHistory < ActiveRecord::Migration
  def up
    remove_column :payment_histories, :description
    add_column :payment_histories, :user_id, :integer
    add_column :payment_histories, :is_latest, :boolean
  end
  
  def down
    add_column :payment_histories, :description, :string
    remove_column :payment_histories, :user_id
    remove_column :payment_histories, :is_latest
  end
end
