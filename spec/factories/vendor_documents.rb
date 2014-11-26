# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :vendor_document do
    document_file_name { Faker::Lorem.word }
    document_content_type "image"
    document_file_size 17
    association :user
    association :vendor_insurance
  end
end
