FactoryGirl.define do
  factory :issue do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    priority { ["High", "Low", "Normal"].sample }

    association :assignee, factory: [:user, :confirmed]
    association :assigner, factory: [:user, :confirmed]
    association :subject, factory: [:vendor, :account, :event].sample
  end
  
end
