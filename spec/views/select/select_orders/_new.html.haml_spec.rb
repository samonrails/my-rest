# require 'spec_helper'

# describe "/select/select_orders/_new" do

# 	let(:select_order) { create(:select_order)}

# 	before do
# 		assign(:select_order, select_order)
# 		@select_event = select_order.select_event
# 		render
# 	end

# 	it "has the add order headline" do
# 		rendered.should have_selector("h3", text: "Add Order - Choose User")
# 	end
	
# 	it "has form to select user" do
# 		rendered.should have_selector 'form' do |s|
# 			s.should have_selector 'input', type: 'collection', name: 'select_order[user]'
# 			s.should have_selector 'input', type: 'hidden', value: "#{@select_event.id}"
# 			s.should have_selector 'input', type: 'submit'
# 		end
# 	end
# end