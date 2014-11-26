FactoryGirl.define do 
  factory :building do 
    name                    { Faker::Name.name + " Building" }
    insurance_requirements  { Faker::Lorem.word }
    insurance_required      { true }
    parking_information     { Faker::Lorem.paragraph }
    loading_information     { Faker::Lorem.paragraph }
    site_directions         { Faker::Lorem.paragraph }
    contact_name            { Faker::Name.name }
    contact_title           "Building Manager"
    contact_email           { Faker::Internet.email }
    contact_phone           { Faker::PhoneNumber.phone_number }
    contact_cell            { Faker::PhoneNumber.phone_number }
    contact_fax             { Faker::PhoneNumber.phone_number }

    timezone                "Central Time (US & Canada)"
    
    association :market
    association :address


    factory :building_with_assets do
      
      ignore do
        asset_count 4
      end

      after(:build) do |building, evaluator|
        FactoryGirl.create_list(:asset, evaluator.asset_count,
          owner: building
        )
      end
    end
  end 
end