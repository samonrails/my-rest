require 'spec_helper'

describe MealType do
  context "available values" do
    it "should not be nil" do
      MealType.available_values.should_not be_nil
    end

    it "should contain an array of needed strings" do
      MealType.available_values.should eq(['combinations', 'entrees', 'appetizers', 'salads', 'sides', 'desserts', 'beverages'])
    end

    it "should have class methods for each value in the available_values array" do
      props = MealType.available_values
      meal_types = MealType.available_values
      meal_types.each { |type| MealType.send(type).should_not be_nil }
    end

    it "should fail if there is an available_value without a class method" do
      meal_types = MealType.available_values << 't'
      meal_types.each { |type| MealType.send(type).should_not be_nil unless type == 't'}
    end
  end
end
