require 'rails_helper'

RSpec.feature 'Search Trips' do
  before do
    @user = FactoryGirl.create(:user)
    @trip = FactoryGirl.create(:trip, user_id: @user.id)
    @trip2nd = FactoryGirl.create(:trip, title: 'Another trip', start_date: '12/05/15', end_date: '27/05/15', user_id: @user.id)

    @atag = 'fun, cold'
    @trip.tag_list = @atag
    @trip.save
    @trip2nd.tag_list = @atag
    @trip2nd.save

    login_as(@user, :scope => :user)

    visit dashboard_path
    click_link 'search_page_link'
  end

  scenario 'do a search on location' do
    fill_in 'location_search', with: @trip.start_loc

    click_button 'Search Trips'

    expect(page).to have_content(@trip.title)
  end

  scenario 'do a search on tag' do
    fill_in 'tag_search', with: @atag

    click_button 'Search Trips'

    expect(page).to have_content(@trip.title)
  end

  scenario 'do a full search' do
    fill_in 'title_search', with: @trip2nd.title
    fill_in 'date_beg', with: @trip2nd.start_date
    fill_in 'date_end', with: @trip2nd.end_date
    fill_in 'tag_search', with: 'fun'

    click_button 'Search Trips'

    expect(page).to have_content(@trip2nd.title)
    expect(page).to_not have_content(@trip.title)
  end

  scenario 'do an unsuccessful search' do
    fill_in 'location_search', with: 'mars'

    click_button 'Search Trips'

    expect(page).to have_content(I18n.t('trip_search_no_results'))
  end

end