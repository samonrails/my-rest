FactoryGirl.define do 
  factory :inventory_item do 
    name_vendor { Faker::Name.name }
    name_public { Faker::Name.name }
    description { Faker::Lorem.sentence }
    cogs 4
    retail_price 5
    sku { Faker::AddressUS.zip_code }
    featured false
    meal_type { MealType.available_values.sample }

    association :vendor

    trait :perks do
      perks_price { rand(6.12) }
      product_type ProductType.perks
    end

  end

  factory :option_inventory_item, class: InventoryItem do 
    name_vendor { Faker::Lorem.word }
    name_public { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    cogs 4
    retail_price 5
    sku { Faker::AddressUS.zip_code }
    featured false
    meal_type { MealType.available_values.sample }

    association :vendor

    trait :perks do
      perks_price { rand(6.12) }
      product_type ProductType.perks
    end
    
    inventory_item_option true

  end
end
