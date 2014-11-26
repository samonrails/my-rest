class AddVoucherIdToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :voucher_group_id, :integer
  end
end
