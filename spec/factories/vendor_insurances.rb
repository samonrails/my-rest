# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :vendor_insurance do
    insurance_effective_date Date.today - 2
    insurance_expiration_date Date.today
    association :building
    association :user
    association :vendor
  end
end
