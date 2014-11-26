class CateringPricing
  # The sell price adjust for just account level discounts. Some price do not
  # receive bulk level vendor discounts.
  # ---------------------------------------------------------------------------
  def self.catering_sell_price cogs_cents, user=nil
    if user
      account_id = get_account_tier user
      account_pricing_tier_price cogs_cents, account_id
    else
      Event.calculate_sell_price_using_standard_pricing_tier cogs_cents 
    end
  end

  # Assume GP of 20% if no pricing tier exists
  # ---------------------------------------------------------------------------
  def self.account_pricing_tier_price cogs, account_id
    return nil if cogs.nil?
    account_pricing_tier = AccountPricingTier.where(account_id: account_id, product: Product.catering).first()
    tier = PricingTier.find(account_pricing_tier.pricing_tier_id).try(:gross_profit) unless account_pricing_tier.nil? 
    cogs / (1 -  (tier || 20.0) / 100)
  end

  # Private: find the appropriate account pricing tier to apply.  
  # ---------------------------------------------------------------------------
  def self.get_account_tier user, account_id=nil
    user.account_roles.first.try(:account_id)
  end
end