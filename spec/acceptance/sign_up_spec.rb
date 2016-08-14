require 'rails_helper'

feature 'User sign in' do
  let(:user) { create(:user) }

  scenario 'Non-registered user try to sign up' do
    visit root_path
    click_on I18n.t('auth.sign_up_link')

    fill_in I18n.t('activerecord.attributes.user.email'), with: 'new@user.com'
    fill_in I18n.t('activerecord.attributes.user.password'), with: '12345678'
    fill_in I18n.t('activerecord.attributes.user.password_confirmation'), with: '12345678'
    click_on I18n.t('auth.sign_up')

    expect(page).to have_content I18n.t('auth.registrations.signed_up')
    expect(current_path).to eq root_path
  end

  scenario 'Registered user try to sign up' do
    User.create!(email: 'user@test.com', password: '12345678')

    visit root_path
    click_on I18n.t('auth.sign_up_link')

    fill_in I18n.t('activerecord.attributes.user.email'), with: 'user@test.com'
    fill_in I18n.t('activerecord.attributes.user.password'), with: '12345678'
    fill_in I18n.t('activerecord.attributes.user.password_confirmation'), with: '12345678'
    click_on I18n.t('auth.sign_up')

    expect(page).to have_content "#{I18n.t('activerecord.attributes.user.email')} #{I18n.t('errors.messages.taken')}"
  end

  scenario 'Authenticated user try to sign up' do
    User.create!(email: 'user@test.com', password: '12345678')
    visit root_path
    click_on I18n.t('auth.sign_in_link')

    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    click_on I18n.t('auth.sign_in')

    expect(page).to_not have_link I18n.t('auth.sign_up_link')
  end

  scenario 'With invalid data' do
    visit root_path
    click_on I18n.t('auth.sign_up_link')

    fill_in I18n.t('activerecord.attributes.user.email'), with: nil
    fill_in I18n.t('activerecord.attributes.user.password'), with: nil
    fill_in I18n.t('activerecord.attributes.user.password_confirmation'), with: nil

    click_on I18n.t('auth.sign_up')

    expect(page).to have_content "#{I18n.t('activerecord.attributes.user.email')} #{I18n.t('errors.messages.blank')}"
    expect(page).to have_content "#{I18n.t('activerecord.attributes.user.password')} #{I18n.t('errors.messages.blank')}"
  end
end
