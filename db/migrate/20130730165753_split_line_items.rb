class SplitLineItems < ActiveRecord::Migration
  def up

    LineItem.select{|li| !li.payable_party.nil? && !li.billable_party.nil?}.each do |li_expense|
      if li_expense.line_item_sub_type == "Menu-Fee" && li_expense.menu_template_id.nil?
        sku = li_expense.sku.dup
        sku.slice!("MT-")
        li_expense.menu_template_id = sku.to_i
      end

      li_revenue = li_expense.dup
      li_revenue.update_attributes(:include_price_in_expense => nil, :payable_party => nil, :tax_rate_expense => nil, :unit_price_expense_cents => 0)
      li_revenue.save

      li_expense.update_attributes(:include_price_in_revenue => nil, :billable_party => nil, :tax_rate_revenue => nil, :unit_price_revenue_cents => 0)
      li_expense.save

      li_revenue.opposing_line_item_id = li_expense.id
      li_expense.opposing_line_item_id = li_revenue.id
      li_revenue.save
      li_expense.save
    end

  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Can't undo LineItem split"
  end
end
