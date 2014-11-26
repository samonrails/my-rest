FactoryGirl.define do 
  factory :order, class: Catering::Order do
    event_notes {Faker::Lorem.sentence}
    association :user
    association :location, :factory => :spot_location
    association :event
    association :contact
    association :account
    total "12500"
    event_date (Time.now + 1.day)
    order_builder_dump {{:catering_order_menus => {},:on_account => "on_account", :account_id =>""}}
    guest_count "90"
    created_at Date.today-2
    updated_at Date.today
    zipcode "60607"
    
  end
end