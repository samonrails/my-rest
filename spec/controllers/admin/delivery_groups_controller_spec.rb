require "spec_helper"

describe Admin::DeliveryGroupsController do
  let(:user){ FactoryGirl.create(:user) }
  let(:account){ FactoryGirl.create(:account) }
  let(:location){ FactoryGirl.create(:location, account: account) }
  let(:dg_params){ FactoryGirl.attributes_for(:delivery_group, location_ids: [location.id]) }
  let!(:delivery_group){ FactoryGirl.create(:delivery_group, user_id: user.id, location_ids: [location.id]) }

  before do
    request.env['HTTPS'] = 'on'
    request.env['HTTP_REFERER'] = ':back'

    sign_in_user(user)
  end

  describe "POST #create" do
    context "when valid" do
      def do_post
        post :create, delivery_group: dg_params
      end

      it "should create a new Delivery Group" do
        expect{ do_post }.to change(DeliveryGroup, :count).by(1)
      end

      it "should show a notice" do
        do_post
        expect(flash[:notice]).to match /created/
      end
    end

    context "when it fails" do
      def do_post
        dg_params.delete(:location_ids)
        post :create, delivery_group: dg_params
      end

      it "should not create a new Delivery Group" do
        expect{ do_post }.to change(DeliveryGroup, :count).by(0)
      end

      it "should show an error" do
        do_post
        expect(flash[:error]).to be_present
      end
    end
  end

  describe "PUT #update" do
    context "when valid" do
      def do_put
        dg_params[:name] = "Something New"
        put :update, id: delivery_group.id, delivery_group: dg_params
      end

      it "should update the Delivery Group" do
        expect do
          do_put
          delivery_group.reload
        end.to change(delivery_group, :name).to("Something New")
      end

      it "should show a notice" do
        do_put
        expect(flash[:notice]).to match /updated/
      end
    end

    context "when it fails" do
      def do_put
        dg_params[:location_ids] = []
        put :update, id: delivery_group.id, delivery_group: dg_params
      end

      it "should not create a new Delivery Group" do
        expect{do_put}.to change(DeliveryGroup, :count).by(0)
      end

      it "should show an error" do
        do_put
        expect(flash[:error]).to be_present
      end
    end
  end

  describe "DELETE #destroy" do
    def do_delete
      delete :destroy, id: delivery_group.id
    end

    it "should update the Delivery Group" do
      expect{do_delete}.to change(DeliveryGroup, :count).by(-1)
    end

    it "should show a notice" do
      do_delete
      expect(flash[:notice]).to match /deleted/
    end
  end
end
