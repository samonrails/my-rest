FactoryGirl.define do
  factory :vendor_product_type do
    association :vendor
    product_type "perks"
    status 'inactive'
  end
end

