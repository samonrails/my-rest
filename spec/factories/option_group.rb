# == Schema Information
#
# Table name: option_groups
#
#  id       :integer          not null, primary key
#  name     :string(255)
#  included :integer
#  max      :integer
#

FactoryGirl.define do 
  factory :option_group do
    name { Faker::Lorem.word }
    included 1
    max 2
  end
end

