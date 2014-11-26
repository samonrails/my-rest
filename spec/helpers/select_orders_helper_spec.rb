# require 'spec_helper'

# describe SelectOrdersHelper do

# 	describe "displaying select order information" do
# 		let(:select_order){ create(:select_order) }
# 		let(:item1){ create(:select_order_item) }
# 		let(:item2){ create(:select_order_item, quantity: 3) }

# 		it "#select_order_date" do
# 			delivery_date_str = select_order.select_event.delivery_time.strftime("%Y-%m-%d")
# 			expect(select_order_date(select_order)).to eq(delivery_date_str)
# 		end

# 		it "#select_order_time" do
# 			delivery_time_str = select_order.select_event.delivery_time.strftime("%I:%M %p")
# 			expect(select_order_time(select_order)).to eq(delivery_time_str)
# 		end

# 		describe "displays quantity in an order" do

# 			before do
# 				select_order.select_order_items << item1
# 			end

# 			it "with one item" do
# 				expect(select_order_item_count(select_order)).to eq(1)
# 			end

# 			it "with two items with a quantity" do
# 				select_order.select_order_items << item2
# 				expect(select_order_item_count(select_order)).to eq(4)
# 			end
# 		end

# 		describe "displays vendors in an order" do

			

# 			it "displays correctly with one vendor" do
# 				expect(select_order_vendors(select_order)).to eq("")
# 			end

# 			it "displays correctly with two or more vendors" do
# 			end

# 		end

# 		# it "#select_order_customized" do
# 		# end
# 	end

# end