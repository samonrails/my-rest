FactoryGirl.define do
	factory :select_order_item, :class => Select::SelectOrderItem do
		association :inventory_item
		association :select_order
		quantity 1
	end
end