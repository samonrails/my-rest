# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :select_event do
  	ready_and_bagged 50
  	delivery_time 24.hours.from_now
  	ordering_window_start_time 34.hours.from_now
  	ordering_window_end_time 30.hours.from_now
    default_gratuity 10

  	association :created_by, :factory => :user
  	association :account, factory: :account
  	association :location, factory: :location
  end
end
