class ProductType
  def self.available_values
    %w{perks select managed_services}
  end

  def self.find_products_by_type type
    Product.get_available_products(type)
  end

  def self.select
    return 'select'
  end

  def self.perks
    return 'perks'
  end

  def self.managed_services
    return 'managed_services'
  end
end
