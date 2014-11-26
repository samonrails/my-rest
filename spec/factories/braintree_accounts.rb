# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :braintree_account do
    resource_id 1
    resource_type "MyString"
  end
end
