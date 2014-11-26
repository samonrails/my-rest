# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event_transaction do
    event nil
    transaction_id "MyString"
    status "MyString"
  end
end
