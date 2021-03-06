require 'rails_helper'

feature 'User sign in' do
  let(:user) { create(:user) }

  scenario 'Registered user try to sign in' do
    sign_in user

    expect(page).to have_content I18n.t('auth.sessions.signed_in')
    expect(current_path).to eq my_tasks_path
  end

  scenario 'Non-registered user try to sign in' do
    visit root_path
    click_on I18n.t('auth.sign_in_link')

    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on I18n.t('auth.sign_in')

    expect(page).to have_content I18n.t('auth.failure.invalid', { authentication_keys: :email })
    expect(current_path).to eq new_sessions_path
  end

  scenario 'already signed in user try to sign in' do
    sign_in user

    visit new_sessions_path

    expect(page).to have_content I18n.t('auth.failure.already_authenticated')

    expect(current_path).to eq root_path
  end
end
