require 'rails_helper'

feature 'User sign out' do
  let(:user) { create(:user) }

  scenario 'Authorized user try to sign out' do
    sign_in user

    click_on I18n.t('auth.sign_out_link')
    expect(page).to have_content I18n.t('auth.sessions.signed_out')
  end

  scenario "Non authorized doesn't see sign out button" do
    visit root_path
    expect(page).to_not have_link I18n.t('auth.sign_out_link')
  end
end
