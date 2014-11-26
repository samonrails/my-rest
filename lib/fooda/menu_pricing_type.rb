class MenuPricingType

  def self.available_values
    %w{item_level menu_level}
  end

  def self.friendly_name menu_pricing_type
    if menu_pricing_type == MenuPricingType.item_level
      return "A La Carte"
    elsif menu_pricing_type == MenuPricingType.menu_level
      return "Per Person Package"
    end
    return nil
  end

  def self.item_level
    "item_level"
  end

  def self.menu_level
    "menu_level"
  end
end