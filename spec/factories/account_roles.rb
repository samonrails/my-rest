FactoryGirl.define do
  factory :account_role do
    association :user, :factory => :user
    association :account, :factory => :account
    role { ["member", "administrator"].sample }
  end
end
