require 'rails_helper'

RSpec.feature 'CRED operations for Trips' do
    before do
        @trip = FactoryGirl.build(:trip)
        @user = FactoryGirl.create(:user)

        visit root_path
        
        sign_in

        click_link 'create_trip_link'

        fill_in 'Title', with: @trip.title
        fill_in 'Description', with: @trip.description
        fill_in 'Start loc', with: @trip.start_loc
        fill_in 'End loc', with: @trip.end_loc
        fill_in 'Image', with: @trip.image
        @tags = 'awesome, cool, pretty'
        fill_in 'Tag list', with: @tags
    end

    scenario 'Create/Show Trip' do
        click_button 'Create Trip'

        expect(page).to have_content(I18n.t 'trip_created')

        expect(page).to have_content(@trip.title)
        expect(page).to have_content(@trip.description)
        expect(page).to have_content(@trip.start_loc)
        expect(page).to have_content(@trip.end_loc)

        within '.trip .owner' do
            expect(page).to have_content('Created by ' << @user.name)
        end
    end
    
    scenario 'Edit Trip' do
        click_button 'Create Trip'
        click_link 'Edit'
        fill_in 'Title', with: 'Not The Trip Title'
        fill_in 'Description', with: 'Not the Trip Description'
        click_button 'Update Trip'

        expect(page).to have_content(I18n.t('trip_updated'))
        expect(page).to_not have_content(@trip.title)
        expect(page).to_not have_content(@trip.description)
    end

    scenario 'Delete Trip' do
        click_button 'Create Trip'
        click_link 'delete_trip_button'
        expect(page).to have_content(I18n.t('trip_deleted'))
    end

    scenario 'Cancel Update' do
        click_button 'Create Trip'        
        click_link 'Edit'
        fill_in 'Title', with: 'Editing Title'
        click_link 'cancel_button'

        expect(page).to have_content(@trip.title)
    end

    scenario 'Cancel Creation' do
        click_link 'cancel_button'
        expect(page.current_path).to eq(dashboard_path)

    end

    scenario 'Redirection if trying to enter not made trip' do
        visit '/trips/99'
        expect(page.current_path).to eq(dashboard_path)
        expect(page).to have_content(I18n.t ('trip_not_found'))
    end

    def sign_in
      click_link 'Sign In'
      fill_in 'user_email', with: @user.email
      fill_in 'user_password', with: @user.password
      click_button 'sign_in_button'

      expect(page).to have_content(I18n.t ('devise.sessions.signed_in'))
    end


end

