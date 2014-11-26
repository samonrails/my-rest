FactoryGirl.define do
  factory :market do
    name { Faker::Address.city }
  end
end