class AddDocumentIdToVoucherGroups < ActiveRecord::Migration
  def change
    add_column :voucher_groups, :document_id, :integer
  end
end
