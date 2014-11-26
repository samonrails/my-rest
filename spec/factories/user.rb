FactoryGirl.define do 
  factory :user do 
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.first_name }
    sequence(:email) {|n| "#{first_name}#{n + rand(100000)}@fooda.com" }

    password "new_passwords"
    password_confirmation "new_passwords"
    roles %w[super_admin fooda_employee accounting catering_foodizen foodizen]  
    
    trait :confirmed do
      before(:create) do |user|
        user.skip_reconfirmation!
        user.skip_confirmation!
      end
    end

    trait :unconfirmed do
      password "Welcome1"
      password_confirmation "Welcome1"
    end

  end
end

