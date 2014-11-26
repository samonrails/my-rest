FactoryGirl.define do
  factory :billing_reference_for_account, class: BillingReference do
    association :account
    name        Faker::Lorem.word
    required    [true, false].sample
    data        Faker::Lorem.words
  end
  
  factory :billing_reference_for_event, class: BillingReference do
    association :event
    name        Faker::Lorem.word
    required    [true, false].sample
    data        Faker::Lorem.word
  end
end