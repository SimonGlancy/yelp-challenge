require 'rails_helper'

feature 'restaurants' do
  context 'no restaraunts have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'restaurants have been added' do
    before do
      sign_up
      create_restaurant
    end

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants yet')
    end
  end

  context 'creating restaurants' do
    before { sign_up }

    scenario 'user must be logged in' do
      sign_out
      click_link 'Add a restaurant'
      expect(page).to have_content('Log in')
      expect(page).to have_button("Log in")
    end

    scenario 'prompts user to fill out a form, then displays the new restaurant' do
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq '/restaurants'
    end

    context 'an invaild restaurant' do
      it 'does not let you submit a name that is too short' do
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'kf'
        click_button 'Create Restaurant'
        expect(page).not_to have_css 'h2', text: 'kf'
        expect(page).to have_content 'error'
      end
    end

  end

  context 'viewing restaurants' do
    let!(:kfc){Restaurant.create(name:'KFC')}

    scenario 'lets a user view a restaurant' do
      visit '/restaurants'
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq "/restaurants/#{kfc.id}"
    end
  end

  context 'editing restaurants' do
    before do
      sign_up
      create_restaurant
    end

    scenario 'let a user edit a restaurant' do
      visit '/restaurants'
      click_link 'Edit KFC'
      fill_in 'Name', with: 'Kentucky Fried Chicken'
      click_button 'Update Restaurant'
      expect(page).to have_content 'Kentucky Fried Chicken'
      expect(current_path).to eq '/restaurants'
    end

    scenario 'user can only edit their own restaurant' do
      sign_out
      sign_up(email: 'test2@email.com')
      click_link 'Edit KFC'
      expect(page).to have_content 'You cannot edit this restaurant'
    end
  end

  context 'deleting restaurants' do
    before do
      sign_up
      create_restaurant
    end

    scenario 'User can delete restaurant' do
      visit '/restaurants'
      click_link 'Delete KFC'
      expect(page).not_to have_content 'KFC'
      expect(page).to have_content 'Restaurant deleted sucessfully'
    end

    scenario 'User can only delete their own restaurant' do
      sign_out
      sign_up(email: 'test2@email.com')
      click_link 'Delete KFC'
      expect(page).to have_content 'You cannot delete this restaurant'
    end
  end
end
