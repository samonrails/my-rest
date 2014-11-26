# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :payment_history do
    event nil
    transaction_id "MyString"
    cc_last4 "MyString"
    customer_id "MyString"
    description "MyString"
    status "MyString"
    amount 1.5
  end
end
