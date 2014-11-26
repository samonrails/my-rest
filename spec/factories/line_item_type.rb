FactoryGirl.define do 
  factory :line_item_type do 
    line_item_type {Faker::Lorem.word}
    line_item_sub_type {Faker::Lorem.word}
    sku {Faker::Lorem.word}
  end 
end