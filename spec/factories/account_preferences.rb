FactoryGirl.define do
  factory :cuisine_account_preferences, class: AccountPreference do
    preference_type 'cuisine'
    cuisine ['Italian', 'Asian', 'Indian'].sample
    disposition ['favorite', 'do_not_schedule'].sample
    association :account
  end

  factory :vendor_account_preferences, class: AccountPreference do
    preference_type 'vendor'
    association :vendor
    disposition ['favorite', 'do_not_schedule'].sample
    association :account
  end
end