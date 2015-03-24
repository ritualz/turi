require 'rails_helper'

RSpec.describe EquipmentItemsController, type: :controller do
    before do
        @user = FactoryGirl.create(:user)
        @trip = FactoryGirl.create(:trip)
        FactoryGirl.create(:participant, :trip_id => @trip.id, :user_id => @user.id, participant_role_id: ParticipantRole.owner.id)
        @equipment_list = FactoryGirl.create(:equipment_list, :trip_id => @trip.id)
        @equipment_item = FactoryGirl.build(:equipment_item)
        sign_in(@user)

        # set http_referer to root_path, to make :back redirects work in rspec
        request.env['HTTP_REFERER'] = root_path        
    end

    describe "POST #create" do
        it "Create a valid equipment_item" do
            expect { post :create, :equipment_list_id => @equipment_list.id, :trip_id => @trip.id , :equipment_item => FactoryGirl.attributes_for(:equipment_item) }.to change(EquipmentItem, :count).by(1)
            expect(flash[:notice]).to eq(I18n.t 'trip_equipment_list_equipment_item_created')
        end

        it "Create a valid EquipmentItem, for a non existing equipment_list" do
            post :create, :equipment_list_id => 999, :trip_id => @trip.id, :equipment_item => FactoryGirl.attributes_for(:equipment_item)
            expect(flash[:alert]).to eq(I18n.t 'trip_equipment_list_not_found')
        end

        it "Render the for again, if something went wrong" do 
            post :create, :equipment_list_id => @equipment_list.id, :trip_id => @trip.id, :equipment_item => FactoryGirl.attributes_for(:equipment_item, :name => nil)
            expect(flash[:alert]).to eq(I18n.t 'trip_equipment_list_equipment_item_not_created')
            expect(response).to render_template :new
        end
    end

    describe "GET #show" do
        it "render and assigns the #show" do
            item = FactoryGirl.create(:equipment_item, :equipment_list_id => @equipment_list.id, :user_id => @user.id)
            get :show, :trip_id => @trip.id, :equipment_list_id => @equipment_list.id, :id => item.id
            expect(assigns(:equipment_item)).to eq(item)
            expect(response).to render_template :show
        end

        it "Get a unvalid EquipmentItem" do
            get :show, :trip_id => @trip.id, :equipment_list_id => @equipment_list.id, :id => 999
            expect(flash[:alert]).to eq(I18n.t 'trip_equipment_list_equipment_item_not_found')
        end
    end

    describe "PUT #edit" do
        before do
            @equipment_item = FactoryGirl.create(:equipment_item, :equipment_list_id => @equipment_list.id, :user_id => @user.id)
        end

        it "locate the requested EquipmentItem and redirect to #show equipment_item" do
            put :update, :trip_id => @trip.id, :equipment_list_id => @equipment_list.id, :id => @equipment_item, :equipment_item => FactoryGirl.attributes_for(:equipment_item)
            expect(assigns(:equipment_item)).to eq(@equipment_item)
            expect(flash[:notice]).to eq(I18n.t 'trip_equipment_list_equipment_item_updated')
        end

        it "Change @equipment_item's attributes" do
            put :update, :trip_id => @trip.id, :equipment_list_id => @equipment_list.id, :id => @equipment_item, :equipment_item => FactoryGirl.attributes_for(:equipment_item, :name => 'Some other item', :price => 42)
            @equipment_item.reload
            expect(@equipment_item.name).to eq('Some other item')
            expect(@equipment_item.price).to eq(42)

        end

        it "invalid/missing attributes, should not change value of item" do
            put :update, :trip_id => @trip.id, :equipment_list_id => @equipment_list.id, :id => @equipment_item, :equipment_item => FactoryGirl.attributes_for(:equipment_item, :name => nil, :price => 42)
            @equipment_item.reload
            expect(@equipment_item.price).to_not eq(42)
            expect(flash[:alert]).to eq(I18n.t 'trip_equipment_list_equipment_item_not_updated')
        end
    end

    describe "DELETE" do
        before do
            @equipment_item = FactoryGirl.create(:equipment_item, :equipment_list_id => @equipment_list.id, :user_id => @user.id)

        end
        it "Deletes the equipment_item" do
            expect { delete :destroy , :trip_id => @trip.id, :equipment_list_id => @equipment_list.id, :id => @equipment_item.id }.to change(EquipmentItem, :count).by(-1)
            expect(response).to redirect_to trip_equipment_list_path(@trip.id, @equipment_list.id)
            expect(flash[:notice]).to eq(I18n.t 'trip_equipment_list_equipment_item_deleted')
        end 
    end

end
