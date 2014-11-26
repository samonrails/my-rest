FactoryGirl.define do
  factory :comment do
    description { Faker::Lorem.paragraph }

    association :issue
    association :user
  end
end
