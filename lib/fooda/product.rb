# A specific product belonging to a product type family

class Product

  # Simple value object.
  TYPES = {
    "perks" => %w{popup},
    "select" => %w{select},
    "managed_services" => %w{catering prepaid_popup_gold prepaid_popup_platinum financial_m_s}
  }

  def self.available_values
    TYPES.values.flatten.uniq
  end

  def self.all
    TYPES.values.flatten.uniq
  end

  def self.financial_values
    return [self.financial_m_s]
  end

  def self.non_financial_values
    return self.available_values - self.financial_values
  end

  def self.popup
    return 'popup'
  end

  def self.select
    return 'select'
  end

  def self.catering
    return 'catering'
  end

  def self.prepaid_popup_gold
    return 'prepaid_popup_gold'
  end

  def self.prepaid_popup_platinum
    return 'prepaid_popup_platinum'
  end

  def self.financial_m_s
    return 'financial_m_s'
  end

  def self.find_parent product
    TYPES.each do |key, value|
      if value.include?(product)
        return key
      end
    end
    return nil
  end
  
  # Find all products belonging to the perks family
  # ProductType.find_products_by_type('perks') # => 'popup'
  def self.get_available_products product_type
    TYPES[product_type]
  end
end

