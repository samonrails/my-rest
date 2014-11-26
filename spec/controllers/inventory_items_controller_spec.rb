require 'spec_helper'

describe InventoryItemsController do

  before(:each) do
    sign_in_user
    @vendor = FactoryGirl.create :vendor
    request.env['HTTPS'] = 'on'
  end

  describe do
    inventory_item = {:name_vendor => "Italian Beef", :name_public => "Hot Dog", :meal_type => "combinations", 
                    :inventory_item_option => 0, :product_types_allowed => {:perks => "on", :managed_services => "on"}, 
                    :description => "The delicious item you taste buds would love.", :tag_list => "Breakfast,Bakery", 
                    :external_tag_list => "Beef,Bread", :dietary_restriction_list => "Kosher,Vegan", :cogs => "10.50", 
                    :perks_price => "14.10", :retail_price => "15.25", :premium_price => "30.98"}

    describe 'POST /vendors/:vendor_id/inventory_items' do
      it "should create inventory item" do
        assert_difference 'InventoryItem.count' do
          post :create, :inventory_item => inventory_item, :vendor_id => @vendor.id
       end
        expect_redirect_to edit_vendor_inventory_item_path(@vendor, assigns(:inventory_item))
        expect(flash[:notice]).to eq "Inventory item created."
      end
  
      it "should not create inventory item without necessary fields" do
        assert_difference 'InventoryItem.count', 0 do
          post :create, :inventory_item => inventory_item.merge(:name_vendor => '', :name_public => ''), :vendor_id => @vendor.id
       end
        expect_redirect_to(vendor_path @vendor, :selected => 'inventory_items')
        expect(flash[:error]).to eq "Error creating inventory item. - Name vendor can't be blank, Name public can't be blank"
      end
    end

    describe 'PUT /vendors/:vendor_id/inventory_items/:id' do
      ii = FactoryGirl.create :inventory_item

      it "should update inventory item" do
        put :update, :inventory_item => inventory_item, :vendor_id => ii.vendor.id, :id => ii.id
        expect_redirect_to vendor_path(ii.vendor, :new_inventory_item => false, :selected => 'inventory_items')
        expect(flash[:notice]).to eq "Inventory item updated."
        expect(ii.reload.name_public).to eq "Hot Dog"
      end

      it "should update inventory item and start building another new inventory item" do
        put :update, :inventory_item => inventory_item, :vendor_id => ii.vendor.id, :id => ii.id, :submit => "Save & Add Another"
        expect_redirect_to vendor_path(ii.vendor, :new_inventory_item => true, :selected => 'inventory_items')
        expect(flash[:notice]).to eq "Inventory item updated."
        expect(ii.reload.name_public).to eq "Hot Dog"
      end
    end

    describe 'DELETE /vendors/:vendor_id/inventory_items/:id' do
      it 'should destroy inventory item' do
        ii = FactoryGirl.create :inventory_item
        assert_difference 'InventoryItem.count', -1 do
          delete :destroy, :vendor_id => ii.vendor.id, :id => ii.id
        end
        expect_redirect_to vendor_path(ii.vendor, :selected => 'inventory_items')
        expect(flash[:notice]).to eq "Inventory item deleted."
      end

      it 'should not be able to destroy if have some restricted dependents' do
        ii = @vendor.inventory_items.create inventory_item
        delete :destroy, :vendor_id => @vendor.id, :id => ii.id
        expect_redirect_to vendor_path(@vendor, :selected => 'inventory_items')
      end
    end

    describe do
      ii = FactoryGirl.create :inventory_item
      option_ii = FactoryGirl.create :option_inventory_item
      other_option = FactoryGirl.create :option_inventory_item

      describe 'POST /vendors/:vendors_id/inventory_items/:id/create_option_group' do
        it "should create option group for existing inventory item" do
          assert_difference 'ii.option_groups.count' do
            post :create_option_group, :name => "My Option Group", :included => 1, :required => 1, 
                                      :max => 2, :item_ids => [option_ii.id], :vendor_id => ii.vendor.id, 
                                      :id => ii.id
          end
          expect_redirect_to edit_vendor_inventory_item_path(ii.vendor, ii)
          expect(flash[:notice]).to eq("Inventory Item Option Group added successfully")
        end

        it "should not create option group without any name" do
          post :create_option_group, :name => "", :included => "", :required => "", 
                                    :max => "", :item_ids => "", :vendor_id => ii.vendor.id, 
                                    :id => ii.id
          expect_redirect_to edit_vendor_inventory_item_path(ii.vendor, ii)
          expect(flash[:error]).to eq("Error adding Inventory Item Option Group - Name can't be blank")
        end
      end

      describe 'POST /vendors/:vendors_id/inventory_items/:id/update_option_group' do
        it "should update option group for existing inventory item" do
          post :create_option_group, :name => "My Option Group", :included => 1, :required => 1, 
                                    :max => 2, :item_ids => [option_ii.id], :vendor_id => ii.vendor.id, 
                                    :id => ii.id
          new_option_group = assigns(:option_group)
          assert_difference 'new_option_group.inventory_items.count' do
            post :update_option_group, :name => "My Favorite Group", :included => 2, :required => 1, 
                                     :max => 2, :item_ids => [option_ii.id, other_option.id], :vendor_id => ii.vendor.id, 
                                     :id => ii.id, :option_group_id => new_option_group.id
          end
          expect_redirect_to edit_vendor_inventory_item_path(ii.vendor, ii)
          expect(new_option_group.reload.name).to eq("My Favorite Group")
        end
      end

      describe 'DELETE /vendors/:vendors_id/inventory_items/:id/delete_option_group?option_group_id=:option_group_id' do
        ii = FactoryGirl.create :inventory_item

        it "should destroy option group for existing inventory item" do
          post :create_option_group, :name => "My Favorite Group", :included => 2, :required => 1, 
                                    :max => 2, :item_ids => [option_ii.id, other_option.id], :vendor_id => ii.vendor.id, 
                                    :id => ii.id
          new_option_group = assigns(:option_group)
          assert_difference 'ii.option_groups.count', -1 do
            post :delete_option_group, :vendor_id => ii.vendor.id, :id => ii.id, :option_group_id => new_option_group.id
          end
          expect_redirect_to edit_vendor_inventory_item_path(ii.vendor, ii)
          expect(flash[:notice]).to eq("Inventory Item option group deleted successfully")
        end
      end
    end
  end
end