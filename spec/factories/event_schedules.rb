# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :event_schedule do
    product { Faker::Lorem.word }
    association :location, :factory => :spot_location
    association :contact
    association :account
    schedule_start_date Date.tomorrow
    event_start_time Date.tomorrow
    meal_period { %w(Breakfast Lunch).sample }
    association :created_by, :factory => :user
    created_at Date.tomorrow
    days_to_schedule 30
    schedule '{"interval":1,"until":null,"count":null,"validations":null,"rule_type":"IceCube::DailyRule"}'
  end
end