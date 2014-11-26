class AddPayableAndBillablePartyColumnsToLineItem < ActiveRecord::Migration
  def change
    add_column :line_items, :billable_party_type, :string
    add_column :line_items, :billable_party_id, :integer
    add_column :line_items, :payable_party_type, :string
    add_column :line_items, :payable_party_id, :integer

    remove_column :line_items, :entity_expense
    remove_column :line_items, :entity_revenue
  end
end
