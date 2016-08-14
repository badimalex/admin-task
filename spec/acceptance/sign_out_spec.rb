require 'rails_helper'

feature 'User sign out' do
  scenario 'Authorized user try to sign out' do
    User.create!(email: 'user@test.com', password: '12345678')

    visit new_session_path

    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    click_on I18n.t('auth.sign_in')

    click_on I18n.t('auth.sign_out_link')
    expect(page).to have_content I18n.t('auth.sessions.signed_out')
  end

  scenario "Non authorized doesn't see sign out button" do
    visit root_path
    expect(page).to_not have_link I18n.t('auth.sign_out_link')
  end
end
