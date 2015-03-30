require 'rails_helper'

RSpec.describe EquipmentAssignmentsController, type: :controller do
    before do
        @owner = FactoryGirl.create(:user)
        @editor = FactoryGirl.create(:user)
        @viwer = FactoryGirl.create(:user)
        @stranger = FactoryGirl.create(:user)
        @trip = FactoryGirl.create(:trip)
        FactoryGirl.create(:participant, :trip_id => @trip.id, :user_id => @owner.id, :participant_role_id => ParticipantRole.owner.id)
        FactoryGirl.create(:participant, :trip_id => @trip.id, :user_id => @editor.id, :participant_role_id => ParticipantRole.editor.id)


        @equipment_list = FactoryGirl.create(:equipment_list, :trip_id => @trip.id)
        @equipment_item = FactoryGirl.create(:equipment_item, :equipment_list_id => @equipment_list.id, :user_id => @owner.id)


        # set http_referer so redirect_to :back will be to the root_path
        request.env["HTTP_REFERER"] = root_path
        sign_in(@owner)            
    end

    describe "POST #create" do
        before do
            @equipment_assignment = FactoryGirl.build(:equipment_assignment, :equipment_item_id => @equipment_item.id, :number => 2)
        end

        it "Create a valid equipment_assignment for the owner as the owner" do
            expect { 
                post :create, :trip_id => @trip.id, :equipment_list_id => @equipment_list.id, :equipment_item_id => @equipment_item.id, :equipment_assignment => FactoryGirl.attributes_for(:equipment_assignment, :user_email => @owner.email, :number => 2)
            }.to change(EquipmentAssignment, :count).by(1)
            expect(flash[:notice]).to eq(I18n.t 'trip_equipment_assignment_created')
        end

        it "Create a valid equipment_assignment without a user email" do
            expect { 
                post :create, :trip_id => @trip.id, :equipment_list_id => @equipment_list.id, :equipment_item_id => @equipment_item.id, :equipment_assignment => FactoryGirl.attributes_for(:equipment_assignment, :user_email => "")
            }.to change(EquipmentAssignment, :count).by(1)
            expect(flash[:notice]).to eq(I18n.t 'trip_equipment_assignment_created')
        end

        it "Create a valid equipment_assignment with the editors email" do
            expect { 
                post :create, :trip_id => @trip.id, :equipment_list_id => @equipment_list.id, :equipment_item_id => @equipment_item.id, :equipment_assignment => FactoryGirl.attributes_for(:equipment_assignment, :user_email => @editor.email)
            }.to change(EquipmentAssignment, :count).by(1)
            expect(flash[:notice]).to eq(I18n.t 'trip_equipment_assignment_created')
        end
    end

    describe "PUT #edit" do
        before do 
            @equipment_assignment = FactoryGirl.create(:equipment_assignment, :equipment_item_id => @equipment_item.id, :user_id => @owner.id)
        end

        it "Locate the requested EquipmentAssignment" do
            put :update, :trip_id => @trip.id, :equipment_list_id => @equipment_list.id, :equipment_item_id => @equipment_item.id, :id => @equipment_assignment.id, :equipment_assignment => FactoryGirl.attributes_for(:equipment_assignment)
            expect(assigns(:equipment_assignment)).to eq(@equipment_assignment)
            expect(flash[:notice]).to eq(I18n.t 'trip_equipment_assignment_updated')
        end

        it 'change @equipment_assignment attributes' do
            put :update, :trip_id => @trip.id, :equipment_list_id => @equipment_list.id, :equipment_item_id => @equipment_item.id, :id => @equipment_assignment.id, :equipment_assignment => FactoryGirl.attributes_for(:equipment_assignment, :number => 3)
            @equipment_assignment.reload 
            expect(@equipment_assignment.number).to eq(3)            
        end

        it 'invalid/missing attributes, should not change value' do
            put :update, :trip_id => @trip.id, :equipment_list_id => @equipment_list.id, :equipment_item_id => @equipment_item.id, :id => @equipment_assignment.id, :equipment_assignment => FactoryGirl.attributes_for(:equipment_assignment, :number => 42, :user_email => @stranger.email)
            @equipment_assignment.reload
            expect(@equipment_assignment).to_not eq(42)
        end
    end

    describe "POST #delete" do
        before do 
            @equipment_assignment = FactoryGirl.create(:equipment_assignment, :equipment_item_id => @equipment_item.id, :user_id => @owner.id)
        end

        it "delete the equipment_assignment" do
            expect { 
                post :destroy, :trip_id => @trip.id, :equipment_list_id => @equipment_list.id, :equipment_item_id => @equipment_item.id, :id => @equipment_assignment.id
            }.to change(EquipmentAssignment, :count).by(-1)
            expect(response).to redirect_to trip_equipment_list_equipment_item_path(@trip, @equipment_list, @equipment_item)
            expect(flash[:notice]).to eq(I18n.t 'trip_equipment_assignment_deleted')
        end
    end
end
