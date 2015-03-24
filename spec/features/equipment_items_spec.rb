require 'rails_helper'

RSpec.feature "Items for equipment_lists" do
   before do
       @user = FactoryGirl.create(:user)
       @user2 = FactoryGirl.create(:user)
       @user3 = FactoryGirl.create(:user)

       @trip = FactoryGirl.create(:trip, :user_id => @user.id)
       
       FactoryGirl.create(:participant, :trip_id => @trip.id, :user_id => @user.id, :participant_role_id => ParticipantRole.owner.id)
       FactoryGirl.create(:participant, :trip_id => @trip.id, :user_id => @user2.id, :participant_role_id => ParticipantRole.editor.id)
       FactoryGirl.create(:participant, :trip_id => @trip.id, :user_id => @user3.id, :participant_role_id => ParticipantRole.viewer.id)       
       
       @equipment_list = FactoryGirl.create(:equipment_list, :trip_id => @trip.id)
       @item = FactoryGirl.build(:equipment_item)
       login_as(@user, :scope => :user)
       #sign_in_as!(@user)
       
       visit trip_path(@trip)
   end

   scenario "Create a item" do
       click_link 'equipment'
       click_link @equipment_list.name + '_equipment_link'

       expect(page).to have_content(@equipment_list.name)
    
       # The form is hidden, but capybara ignores this 
       fill_in 'equipment_item_name', with: @item.name
       fill_in 'equipment_item_price', with: @item.price
       fill_in 'equipment_item_number', with: @item.number

       click_button 'submit'

       expect(page.current_path).to eq(trip_equipment_list_path(@trip, @equipment_list))
       expect(page).to have_content(I18n.t 'trip_equipment_list_equipment_item_created')

       expect(page).to have_content(@item.name)


       # click the item(show item) and check if the values are correct
       click_link @item.name
       expect(page).to have_content(@user.name)
       expect(page).to have_content(@item.number)
       expect(page).to have_content(@item.price)
   end

   scenario "Edit a item" do
       @item = FactoryGirl.create(:equipment_item, :equipment_list_id => @equipment_list.id, :user_id => @user.id)

       click_link 'equipment'
       click_link @equipment_list.name + '_equipment_link'


       click_link @item.name 
       click_link 'edit_equipment_item'
       fill_in 'equipment_item_name', with: "something else"

       click_button 'submit'
       expect(page.current_path).to eq(trip_equipment_list_path(@trip, @equipment_list))
       expect(page).to have_content(I18n.t 'trip_equipment_list_equipment_item_updated')
    
       expect(page).not_to have_content(@item.name)
   end     

   scenario "Delete a item" do
       @item = FactoryGirl.create(:equipment_item, :equipment_list_id => @equipment_list.id, :user_id => @user.id)
       
       click_link 'equipment'
       click_link @equipment_list.name + '_equipment_link'


       click_link  @item.name
       click_link 'delete_equipment_item'

       expect(page.current_path).to eq(trip_equipment_list_path(@trip, @equipment_list))
       expect(page).to have_content(I18n.t 'trip_equipment_list_equipment_item_deleted')
       expect(page).not_to have_content(@item.name)
   end

   scenario "The creator (without owner role) of the item, can delete it" do
       @item = FactoryGirl.create(:equipment_item, :equipment_list_id => @equipment_list.id, :user_id => @user2.id)
       
       logout(:user)
       login_as(@user2, :scope => :user)
       visit trip_equipment_list_equipment_item_path(@trip, @equipment_list, @item)
       expect(page).to have_link('delete_equipment_item')

       click_link 'delete_equipment_item'
       expect(page.current_path).to eq(trip_equipment_list_path(@trip, @equipment_list))
       expect(page).to have_content(I18n.t 'trip_equipment_list_equipment_item_deleted')
   end

   scenario "Editor can't delete others items but can edit it" do
       @item = FactoryGirl.create(:equipment_item, :equipment_list_id => @equipment_list.id, :user_id => @user.id)

       logout(:user)
       login_as(@user2, :scope => :user)
       visit trip_equipment_list_equipment_item_path(@trip, @equipment_list, @item)
       expect(page).not_to have_link('delete_equipment_item')
       expect(page).to have_link('edit_equipment_item')

       # edit the item 
       click_link 'edit_equipment_item'
       fill_in 'equipment_item_name', with: 'Something'
       click_button 'submit'
       expect(page.current_path).to eq(trip_equipment_list_path(@trip, @equipment_list))
       expect(page).to have_content(I18n.t 'trip_equipment_list_equipment_item_updated')
       expect(page).not_to have_content(@item.name)
   end

   scenario "Viewers can't edit or delete item" do
       @item = FactoryGirl.create(:equipment_item, :equipment_list_id => @equipment_list.id, :user_id => @user.id)

       logout(:user)
       login_as(@user3, :scope => :user)
       visit trip_equipment_list_equipment_item_path(@trip, @equipment_list, @item)
       expect(page).not_to have_link 'edit_equipment_item'
       expect(page).not_to have_link 'delete_equipment_item'
   end
end
