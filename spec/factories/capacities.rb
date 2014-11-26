# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :capacity do
    day { rand(1..7) }
    start_time (Time.now + 5.hours)
    end_time (Time.now + 8.hours)
    is_closed { rand(0..1) }
    association :vendor, :factory => :vendor
  end
end
