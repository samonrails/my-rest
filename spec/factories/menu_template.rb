FactoryGirl.define do
  factory :menu_template do
    name { Faker::Lorem.sentence }
    pricing_type MenuPricingType.item_level
    product_type ProductType.perks
    start_date 2.days.from_now

    association :vendor

    trait :menu_level do
      pricing_type MenuPricingType.menu_level
      cogs { rand(75.0..150.0) }
      sell_price { cogs * 1.11 }
    end

    trait :select do
      product_type ProductType.select
      expiration_date 6.months.from_now
    end

    trait :managed_services do
      product_type ProductType.managed_services
      cogs { rand(200.0..300.00) }
      sell_price { cogs*1.12 }
    end

    # An Old example of a one to many (maybe many to many) factory relationship
    factory :menu_template_with_inventory_items do
      
      ignore do
        inventory_item_count 12
      end

      after(:build) do |menu_template, evaluator|
        FactoryGirl.create_list(:inventory_item, evaluator.inventory_item_count, 
                                vendor: menu_template.vendor)
      end
    end

  end
end