FactoryGirl.define do
	factory :select_order, :class => Select::SelectOrder do
		created_at '2014-01-01'
		updated_at '2014-01-01'
		user_id 1
		status 'cart'
		association :select_event, factory: :select_event
	end
end