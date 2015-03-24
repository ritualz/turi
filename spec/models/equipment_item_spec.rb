require 'rails_helper'

RSpec.describe EquipmentItem, type: :model do
   before do
       @user = FactoryGirl.create(:user)
       trip = FactoryGirl.create(:trip) 
       @equipment_list = FactoryGirl.create(:equipment_list, :trip_id => trip.id)
   end

   it "Has a valid factory" do
       expect(FactoryGirl.create(:equipment_item, user_id: @user.id, equipment_list_id: @equipment_list.id)).to be_valid
   end

   it "is invalid without name" do
       expect {
           FactoryGirl.create(:equipment_item, :name => nil, user_id: @user.id, equipment_list_id: @equipment_list.id)
       }.to raise_error(ActiveRecord::RecordInvalid)
   end
end
