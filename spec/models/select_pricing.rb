require 'spec_helper'

describe SelectPricing do
  before(:each) do
    if PricingTier.all.count == 0
      Fooda::Util::create_pricing_tiers
    end
  end

  let(:inventory_item) { create(:inventory_item, cogs_cents: 7200, retail_price_cents: 9000 ) }

  # Options
  let(:inventory_item_option1) { create(:inventory_item, name_vendor: "Chicken", cogs_cents: 200, premium_price_cents: 0 ) }
  let(:inventory_item_option2) { create(:inventory_item, name_vendor: "Shrimp", cogs_cents: 400, premium_price_cents: 100 ) }
  let(:inventory_item_option3) { create(:inventory_item, name_vendor: "Beef", cogs_cents: 200, premium_price_cents: 0 ) }

  let(:select_event) { create(:select_event) }

  # user_selected_options
  # context "when chicken and shrimp options are selected" do
  #       it "returns the correct combination" do
  #         option_test = SelectPricing::InventoryItemPossibilities.new
  #         options_in_group_ids = [ inventory_item_option1.id, inventory_item_option2.id  ]
  #         option_test.build( select_event, option_group, options_in_group_ids )
  #         #combinations = option_test.possibilites_matrix(1)
  #         #highest_sum = option_test.highest_options_sum( 1 )
  #         ( highest_total, highest_possibilities ) = option_test.highest_priced_options( 1 )
  #         binding.pry
  #         p highest_total
  #         #expect(combinations).to eq([[]])
  #       end
  #     end

  # Create group and put the options in to the group
  describe "::InventoryItemPossibilities" do
    let(:option_test) { SelectPricing::InventoryItemPossibilities.new }

    describe "#highest_options_sum" do
      context "when no items are included" do
        let(:option_group) { create(:option_group, included: 0, inventory_item_id: inventory_item.id )}

        context "when nothing is selected" do
          it "returns the correct price" do
            options_in_group_ids = [ ]
            option_test.build( select_event, option_group, options_in_group_ids )
            total = option_test.highest_options_sum
            expect(total).to eq(Money.new(0))
          end
        end

        context "when chicken is selected" do
          it "returns the correct price" do
            options_in_group_ids = [ inventory_item_option1.id ]
            option_test.build( select_event, option_group, options_in_group_ids )
            total = option_test.highest_options_sum
            expect(total).to eq(Money.new(250))
          end
        end

        context "when chicken and shrimp is selected" do
          it "returns the correct price" do
            options_in_group_ids = [ inventory_item_option1.id, inventory_item_option2 ]
            option_test.build( select_event, option_group, options_in_group_ids )
            total = option_test.highest_options_sum
            expect(total).to eq(Money.new(750))
          end
        end

        context "when chicken, shrimp, and beef is selected" do
          it "returns the correct price" do
            options_in_group_ids = [ inventory_item_option1.id, inventory_item_option2, inventory_item_option3 ]
            option_test.build( select_event, option_group, options_in_group_ids )
            total = option_test.highest_options_sum
            expect(total).to eq(Money.new(1000))
          end
        end
      end

      context "when 1 item is included" do
        let(:option_group) { create(:option_group, included: 1, inventory_item_id: inventory_item.id ) }

        context "when nothing is selected" do
          it "returns the correct price" do
            options_in_group_ids = [ ]
            option_test.build( select_event, option_group, options_in_group_ids )
            total = option_test.highest_options_sum
            expect(total).to eq(Money.new(0))
          end
        end

        context "when chicken is selected" do
          it "returns the correct price" do
            options_in_group_ids = [ inventory_item_option1.id ]
            option_test.build( select_event, option_group, options_in_group_ids )
            total = option_test.highest_options_sum
            expect(total).to eq(Money.new(0))
          end
        end

        context "when chicken and shrimp is selected" do
          it "returns the correct price" do
            options_in_group_ids = [ inventory_item_option1.id, inventory_item_option2 ]
            option_test.build( select_event, option_group, options_in_group_ids )
            total = option_test.highest_options_sum
            expect(total).to eq(Money.new(500))
          end
        end

        context "when chicken, shrimp, and beef is selected" do
          it "returns the correct price" do
            options_in_group_ids = [ inventory_item_option1.id, inventory_item_option2, inventory_item_option3 ]
            option_test.build( select_event, option_group, options_in_group_ids )
            total = option_test.highest_options_sum
            expect(total).to eq(Money.new(750))
          end
        end
      end

      context "when 2 items are included" do
        let(:option_group) { create(:option_group, included: 2, inventory_item_id: inventory_item.id ) }

        context "when nothing is selected" do
          it "returns the correct price" do
            options_in_group_ids = [ ]
            option_test.build( select_event, option_group, options_in_group_ids )
            total = option_test.highest_options_sum
            expect(total).to eq(Money.new(0))
          end
        end

        context "when chicken is selected" do
          it "returns the correct price" do
            options_in_group_ids = [ inventory_item_option1.id ]
            option_test.build( select_event, option_group, options_in_group_ids )
            total = option_test.highest_options_sum
            expect(total).to eq(Money.new(0))
          end
        end

        context "when chicken and shrimp is selected" do
          it "returns the correct price" do
            options_in_group_ids = [ inventory_item_option1.id, inventory_item_option2 ]
            option_test.build( select_event, option_group, options_in_group_ids )
            total = option_test.highest_options_sum
            expect(total).to eq(Money.new(125))
          end
        end

        context "when chicken, shrimp, and beef is selected" do
          it "returns the correct price" do
            options_in_group_ids = [ inventory_item_option1.id, inventory_item_option2, inventory_item_option3 ]
            option_test.build( select_event, option_group, options_in_group_ids )
            total = option_test.highest_options_sum
            expect(total).to eq(Money.new(500))
          end
        end
      end

      context "when 3 items are included" do
        let(:option_group) { create(:option_group, included: 3, inventory_item_id: inventory_item.id ) }

        context "when nothing is selected" do
          it "returns the correct price" do
            options_in_group_ids = [ ]
            option_test.build( select_event, option_group, options_in_group_ids )
            total = option_test.highest_options_sum
            expect(total).to eq(Money.new(0))
          end
        end

        context "when chicken is selected" do
          it "returns the correct price" do
            options_in_group_ids = [ inventory_item_option1.id ]
            option_test.build( select_event, option_group, options_in_group_ids )
            total = option_test.highest_options_sum
            expect(total).to eq(Money.new(0))
          end
        end

        context "when chicken and shrimp is selected" do
          it "returns the correct price" do
            options_in_group_ids = [ inventory_item_option1.id, inventory_item_option2 ]
            option_test.build( select_event, option_group, options_in_group_ids )
            total = option_test.highest_options_sum
            expect(total).to eq(Money.new(125))
          end
        end

        context "when chicken, shrimp, and beef is selected" do
          it "returns the correct price" do
            options_in_group_ids = [ inventory_item_option1.id, inventory_item_option2, inventory_item_option3 ]
            option_test.build( select_event, option_group, options_in_group_ids )
            total = option_test.highest_options_sum
            expect(total).to eq(Money.new(125))
          end
        end
      end
    end

    describe "#possibilites_matrix" do
      context "when no items are included" do
        context "when 0 options are selected" do
          it "returns the correct combination" do
            option_test.build_generic(0)
            combinations = option_test.possibilites_matrix
            expect(combinations).to eq([[]])
          end
        end

        context "when 1 option is selected" do
          it "returns the correct combination" do
            option_test.build_generic(0, ['A'], ["A'"])
            combinations = option_test.possibilites_matrix
            expect(combinations).to eq([["A"]])
          end
        end

        context "when 2 options are selected" do
          it "returns the correct combination" do
            option_test.build_generic(0, ['A', 'B'], ["A'", "B'"])
            combinations = option_test.possibilites_matrix
            expect(combinations).to eq([["A", "B"]])
          end
        end

        context "when 3 options are selected" do
          it "returns the correct combination" do
            option_test.build_generic(0, ['A', 'B', 'C'], ["A'", "B'", "C'"])
            combinations = option_test.possibilites_matrix
            expect(combinations).to eq([["A", "B", "C"]])
          end
        end
      end

      context "when 1 item is included" do
        context "when 0 options are selected" do
          it "returns the correct combination" do
            option_test.build_generic(1)
            combinations = option_test.possibilites_matrix
            expect(combinations).to eq([[]])
          end
        end

        context "when 1 option is selected" do
          it "returns the correct combination" do
            option_test.build_generic(1, ['A'], ["A'"])
            combinations = option_test.possibilites_matrix
            expect(combinations).to eq([["A'"]])
          end
        end

        context "when 2 options are selected" do
          it "returns the correct combination" do
            option_test.build_generic(1, ['A','B'], ["A'","B'"])
            combinations = option_test.possibilites_matrix
            expect(combinations).to eq([["A'", "B"], ["B'", "A"]])
          end
        end

        context "when 3 options are selected" do
          it "returns the correct combination" do
            option_test.build_generic(1, ['A','B','C'], ["A'","B'","C'"])
            combinations = option_test.possibilites_matrix
            expect(combinations).to eq([["A'", "B", "C"], ["B'", "A", "C"], ["C'", "A", "B"]])
          end
        end
      end

      context "when 2 items are included" do
        context "when 0 options are selected" do
          it "returns the correct combination" do
            option_test.build_generic(2)
            combinations = option_test.possibilites_matrix
            expect(combinations).to eq([[]])
          end
        end

        context "when 1 option is selected" do
          it "returns the correct combination" do
            option_test.build_generic(2, ['A'], ["A'"])
            combinations = option_test.possibilites_matrix
            expect(combinations).to eq([["A'"]])
          end
        end

        context "when 2 options are selected" do
          it "returns the correct combination" do
            option_test.build_generic(2, ['A','B'], ["A'","B'"])
            combinations = option_test.possibilites_matrix
            expect(combinations).to eq([["A'", "B'"]])
          end
        end

        context "when 3 options are selected" do
          it "returns the correct combination" do
            option_test.build_generic(2, ['A','B','C'], ["A'","B'","C'"])
            combinations = option_test.possibilites_matrix
            expect(combinations).to eq([["A'", "B'", "C"], ["A'", "C'", "B"], ["B'", "C'", "A"]])
          end
        end
      end

      context "when 3 items are included" do
        context "when 0 options are selected" do
          it "returns the correct combination" do
            option_test.build_generic(3)
            combinations = option_test.possibilites_matrix
            expect(combinations).to eq([[]])
          end
        end

        context "when 1 option is selected" do
          it "returns the correct combination" do
            option_test.build_generic(3, ['A'], ["A'"])
            combinations = option_test.possibilites_matrix
            expect(combinations).to eq([["A'"]])
          end
        end

        context "when 2 options are selected" do
          it "returns the correct combination" do
            option_test.build_generic(3, ['A','B'], ["A'","B'"])
            combinations = option_test.possibilites_matrix
            expect(combinations).to eq([["A'", "B'"]])
          end
        end

        context "when 3 options are selected" do
          it "returns the correct combination" do
            option_test.build_generic(3, ['A','B','C'], ["A'","B'","C'"])
            combinations = option_test.possibilites_matrix
            expect(combinations).to eq([["A'", "B'", "C'"]])
          end
        end
      end
    end
  end
end