FactoryGirl.define do 
  factory :event do 
    name { Faker::Lorem.word + "#{rand(100000)}"}
    event_start_time Date.tomorrow
    meal_period { ["Breakfast", "Lunch"].sample }
    product { ["catering", "prepaid_popup_gold","prepaid_popup_platinum" ].sample }
    quantity { rand(50..100) }
    status { ["proposed", "scheduled", "active", "in_progress"].sample }
    
    setup_start_time 34.hours.from_now
    setup_end_time 34.5.hours.from_now

    association :account
    association :contact
    association :location, :factory => :spot_location
    association :event_transaction_method

    factory :catering_event do
      product { ProductType.find_products_by_type(ProductType.managed_services).sample }
      status Status::Event.scheduled

      event_start_time Date.tomorrow
      setup_start_time 34.hours.from_now
      setup_end_time 34.5.hours.from_now

    end
  end
  
  factory :event_with_owner, class: Event do 
    name { Faker::Lorem.word + "#{rand(100000)}"}
    event_start_time Date.tomorrow
    meal_period { ["Breakfast", "Lunch"].sample }
    product { Product.available_values.sample }
    quantity { rand(50..100) }
    status { Status::Event.available_values.sample }
    
    setup_start_time 34.hours.from_now
    setup_end_time 34.5.hours.from_now

    association :account
    association :contact
    association :location, :factory => :spot_location

    factory :catering_event_with_owner do
      product { ProductType.find_products_by_type(ProductType.managed_services).sample }
      status Status::Event.scheduled

      event_start_time Date.tomorrow
      setup_start_time 34.hours.from_now
      setup_end_time 34.5.hours.from_now
    end
    association :event_owner, :factory => :user
  end 
end