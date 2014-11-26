module InventoryItemsHelper

  def cogs_price inventory_item
    inventory_item.cogs || Money.new(0)
  end

end