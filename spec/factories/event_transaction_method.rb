
FactoryGirl.define do
  factory :event_transaction_method do
    transaction_method "credit_card"
    info1 "David Bremner"
    info2 "1234"
    transaction_card_token "abc123"
    association :user
    party_type "Account"
  end
end
