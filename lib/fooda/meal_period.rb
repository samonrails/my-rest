class MealPeriod

  def self.available_values
    [self.breakfast, self.lunch, self.dinner, self.appetizers]
  end

  def self.breakfast
    "Breakfast / Brunch"
  end

  def self.lunch
    "Lunch"
  end

  def self.dinner
    "Dinner"
  end

  def self.appetizers
    "Appetizers"
  end
end
