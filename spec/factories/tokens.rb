# Read about factories at https://github.com/thoughtbot/factory_girl
data_hash = {:data => "MyString"}
FactoryGirl.define do
  factory :token do
    digest ""
    accessed_at {Time.now + 5.hours}
    expires_at {Time.now + 8.hours}
    data data_hash
  end
end