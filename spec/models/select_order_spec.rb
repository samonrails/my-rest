# require 'spec_helper'

# describe Select::SelectOrder do
	
# 	let (:select_event) { create(:select_event)}
# 	let (:select_order) { create(:select_order)}
# 	let (:item1) { create(:select_order_item, quantity: 1, status: :provisioned)}

# 	before do
# 		select_order.select_order_items << item1
# 	end

# 	it "is valid" do
# 		expect(select_order).to be_valid
# 	end

# 	describe "calculating totals gets correct" do	
		
# 		# it "subtotal" do
# 		# 	expect(select_order.order_subtotal(:provisioned)).to eq(480)
# 		# end

# 		# it "gratuity if default" do
# 		# 	expect(select_order.gratuity_amount(480)).to eq(48)
# 		# end

# 		# it "delivery amount" do
# 		# end

# 		# it "tax amount" do
# 		# 	expect(select_order.tax_amount(480)).to eq(tax)
# 		# end

# 		# it "subsidy amount" do
# 		# end

# 		# it "total amount" do
# 		# end

# 	end

# 	describe "#editing?" do

# 		it "allows editing when in edit mode" do
# 			select_order.edit_mode = true
# 			expect(select_order.editing?).to be_true
# 		end

# 		it "prohibits editing if window passed" do
# 			select_order.select_event.ordering_window_end_time = closed_ordering_window
# 			expect(select_order.editing?).to be_false
# 		end

# 		it "prohibits editing if edit_mode not set" do
# 			select_order.edit_mode = nil
# 			expect(select_order.editing?).to be_false
# 		end
# 	end

# 	# describe "#recalc_totals_for_save" do
# 	# end

# 	describe "#provision_adjustment_items" do

# 		it "will not provision items if ordering window ended" do
# 			select_order.select_event.ordering_window_end_time = closed_ordering_window
# 			expect(select_order.send(:provision_adjustment_items)).to be_false
# 		end

# 		# it "will move items provisioned if in edit mode" do
# 		# end

# 		# it "will move provisioned items to current when no in edit mode" do
# 		# end
# 	end

# 	describe "#ensure_order_can_be_saved" do
		
# 		it "prohibits save when ordering window is closed" do
# 			select_order.select_event.ordering_window_end_time = closed_ordering_window
# 			expect(select_order.send(:ensure_order_can_be_saved)).to be_false
# 		end

# 		it "prohibits save when status is not set" do
# 			select_order.status = nil
# 			expect(select_order.send(:ensure_order_can_be_saved)).to be_false
# 		end

# 		it "saves order if it has 'cart' status" do
# 			select_order.status = 'cart'
# 			expect(select_order.send(:ensure_order_can_be_saved)).to be_true
# 		end

# 		it "saves order if has 'checkout' status" do
# 			select_order.status = 'checkout'
# 			expect(select_order.send(:ensure_order_can_be_saved)).to be_true
# 		end

# 		# it "saves order if checkout complete and user is admin" do
# 		# 	select_order.status = 'checkout_complete'
# 		# 	DETERMINE THAT USER IS ADMIN
# 		# 	expect(select_order.send(:ensure_order_can_be_saved)).to be_true
# 		# end

# 		# it "saves order if checkout is canceled and user is admin" do
# 		# 	select_order.status = 'canceled'
# 		# 	DETERMINE THAT USER IS ADMIN
# 		# 	expect(select_order.send(:ensure_order_can_be_saved)).to be_true
# 		# end

# 		# it "will not save order for checkout if user is not admin" do
# 		# 	select_order.status = 'checkout_complete'
# 		# 	expect(select_order.send(:ensure_order_can_be_saved)).to be_false
# 		# end
# 	end

# 	describe "calculating order totals" do
# 		it "returns the correct quantity" do
# 			select_order.select_order_items.count.should == 1
# 		end
# 	end

# 	def closed_ordering_window
# 		Time.at(0)
# 	end
# end