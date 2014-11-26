FactoryGirl.define do
  factory :vendor do
    name { Faker::Name.name }
    description { Faker::Lorem.sentence 10 }
    website { Faker::Internet.http_url }
    default_tax_rate { rand(6.0..10.0).round(2) }
    association :address
    association :vendor_manager, :factory => :user
    cuisine_list ["Italian"]
    market_list ["Chicago"]
  end
end