class SelectPricing

  def inventory_item_pricing inventory_item, select_event, user=nil
    # Accepts inventory_item_id
  end

  # Calculate the sum of the sell price for any inventory item and the options with the quantity
  # -------------------------------------------------------------------------------------
  def self.quantity_sum_sell_price_select_order_item select_order_item
    self.sum_sell_price_select_order_item(select_order_item) * select_order_item.quantity
  end

  # Calculate the sum of the sell price for any inventory item and the options
  # -------------------------------------------------------------------------------------

  def self.sum_sell_price_select_order_item select_order_item
    sum = Money.new(0)
    select_event = select_order_item.select_order.select_event

    # Cost of the parent item
    sum += self.inventory_item_sell_price(select_order_item.inventory_item, select_event)
    
    # Highest cost of the Options combined
    sum += self.sum_sell_price_inventory_item_options( select_order_item )
    
    sum

  end

  # Calculate the sell price for any inventory item which is not an option
  # Select Parent Inventory Items does not care about premium prices; options do
  # -------------------------------------------------------------------------------------
  def self.sum_sell_price_inventory_item_options select_order_item

    sum = Money.new(0)
    select_event = select_order_item.select_order.select_event

    # Iterate through the option groups for this parent item
    parent_inventory_item = select_order_item.inventory_item
    
    # Inventory item ids of each chosen option
    user_selected_options = select_order_item.select_order_item_options.map(&:inventory_item_id)

    parent_inventory_item.option_groups.each do |option_group|
      
      # Intersect the options in a group with the user selected one 
      options_in_group_ids = option_group.inventory_items.map(&:id) & user_selected_options
      
      # Highest prices for the options combinations
      possibilities = InventoryItemPossibilities.new
      possibilities.build( select_event, option_group, options_in_group_ids )
      sum = possibilities.highest_options_sum
      
    end

    sum
  end

  
  # Calculate the sell price for any inventory item which is not an option
  # Select Parent Inventory Items does not care about premium prices; options do
  # -------------------------------------------------------------------------------------
  def self.inventory_item_sell_price inventory_item, select_event, price_type="cogs"

    price = inventory_item.send price_type
    return Money.new(0) if price.nil?

    calculate_sell_price( select_event, price )
  end


  # Calculate the sell price for any arbitrary amount provided in cents
  # -------------------------------------------------------------------------------------
  def self.calculate_sell_price select_event, arbitrary_amount_cents
    pricing_tier_gross_profit = AccountPricingTier.where(account_id: select_event.account_id, product: Product.select).try(:first).try(:pricing_tier).try(:gross_profit)
    pricing_tier_gross_profit ||= 20.00
    arbitrary_amount_cents + ( arbitrary_amount_cents * (pricing_tier_gross_profit/100) )
  end

  class InventoryItemPrice
    attr_accessor :price, :inventory_item_id

    def initialize(inventory_item_id, price)
      @inventory_item_id = inventory_item_id
      @price = price || Money.new(0)
    end  
  end

  class InventoryItemPossibilities
    attr_accessor :premium_inventory_items, :cogs_inventory_items

    def initialize
      @premium_inventory_items = []
      @cogs_inventory_items = []
      @option_group_included = 0
    end

    def build(select_event, option_group, options_in_group_ids=[] )
      options_in_group_ids.map do |id|
        @premium_inventory_items << InventoryItemPrice.new( id,  SelectPricing.inventory_item_sell_price( InventoryItem.find(id), select_event, "premium_price" )  )
        @cogs_inventory_items << InventoryItemPrice.new( id,  SelectPricing.inventory_item_sell_price( InventoryItem.find(id), select_event, "cogs" )  )
      end
      @option_group_included = option_group.included
    end

    def build_generic( option_group_included=0, array_cogs_inventory_items=[], array_premium_inventory_items=[])
      @cogs_inventory_items = array_cogs_inventory_items
      @premium_inventory_items = array_premium_inventory_items
      @option_group_included = option_group_included
    end

    def combination
      selected_count = @premium_inventory_items.count
      if @option_group_included > selected_count
        @option_group_included = selected_count
      end
      non_included_count = @premium_inventory_items.count - @option_group_included
      premium_combinations = @premium_inventory_items.combination(@option_group_included).to_a
      cogs_combinations = @cogs_inventory_items.combination(non_included_count).to_a.reverse
      return premium_combinations, cogs_combinations
    end

    def zippify( premium_combinations, cogs_combinations )
      premium_combinations.zip(cogs_combinations).map(&:flatten)
    end

    def possibilites_matrix
      (premium_combinations, cogs_combinations) = self.combination
      zippify(premium_combinations, cogs_combinations)
    end

    # Return the highest sum from the combination of options
    # -------------------------------------------------------
    def highest_options_sum
      possibilities = possibilites_matrix
      ( highest_total, highest_possibilities ) = highest_possibility_price( possibilities )
      highest_total
    end

    # Return the combination which yields a higher sum
    # -------------------------------------------------------
    def highest_priced_options
      possibilities = possibilites_matrix
      ( highest_total, highest_possibilities ) = highest_possibility_price( possibilities )
    end

    # From the matrix of possibilities, find out the combination
    # that will yield the highest combination
    # -------------------------------------------------------
    def highest_possibility_price( possibilities )
      highest_price_index = 0
      highest_total = Money.new(0)

      initial = Money.new(0)
      possibilities.each_with_index do |possibility, index|

        total = possibility.inject(initial) { |sum, n| sum + n.price }
        if total > highest_total
          highest_total = total
          highest_price_index = index
        end

      end
      return highest_total, possibilities[ highest_price_index ]
    end

  end

end
