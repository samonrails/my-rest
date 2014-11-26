FactoryGirl.define do 
  factory :asset do 
    resource_file_name { Faker::Lorem.word }
    resource_content_type "image"
    resource_file_size 17 
  end 
end