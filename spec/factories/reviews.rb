# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :review do
    reviewable nil
    contact nil
    rating 1
    content "MyText"
  end
end
