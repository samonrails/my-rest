FactoryGirl.define do 
  factory :line_item do 
    name {Faker::Lorem.word}
    line_item_type Faker::Lorem.word
    notes Faker::Lorem.word
    sku Faker::Lorem.word
    quantity 8
    unit_price_expense 4
    unit_price_revenue 5
    association :event
  end 
end