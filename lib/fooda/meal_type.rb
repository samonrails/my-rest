class MealType

  def self.available_values
    %w{combinations entrees appetizers salads sides desserts beverages}
  end

  def self.friendly_name meal_type
    return meal_type.capitalize
  end

  def self.combinations
    "combinations"
  end

  def self.entrees
    "entrees"
  end

  def self.salads
    "salads"
  end

  def self.sides
    "sides"
  end

  def self.desserts
    "desserts"
  end

  def self.appetizers
    "appetizers"
  end

  def self.beverages
    "beverages"
  end
end
