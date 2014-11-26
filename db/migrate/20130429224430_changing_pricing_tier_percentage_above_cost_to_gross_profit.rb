class ChangingPricingTierPercentageAboveCostToGrossProfit < ActiveRecord::Migration
  def up
    add_column :pricing_tiers, :gross_profit, :decimal
    remove_column :pricing_tiers, :percent_above_cost
  end

  def down
    remove_column :pricing_tiers, :gross_profit
    add_column :pricing_tiers, :percent_above_cost, :decimal
  end
end
