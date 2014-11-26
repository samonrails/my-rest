FactoryGirl.define do 
  factory :address do 
    address1 { Faker::AddressUS.street_address }
    address2 { Faker::AddressUS.secondary_address }
    city { Faker::AddressUS.city }
    state { Faker::AddressUS.state_abbr }
    zip_code { Faker::AddressUS.zip_code }
    country "United States"

    trait :work do
      name "600 West Chicago"
      address1 "600 W. Chicago Ave."
      address2 ""
      city "Chicago"
      state "IL"
      zip_code "60654"
    end
  end 
end