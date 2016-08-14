require 'rails_helper'

feature 'Create task' do
  let(:user) { create(:user) }

  context 'Authenticated' do
    scenario 'sees my tasks button' do
      sign_in user
      expect(page).to have_link I18n.t('task.my')
    end

    xscenario 'sees list of all your tasks' do

    end
  end

  context 'Non-authenticated' do
    scenario 'does not sees my tasks button' do
      visit root_path
      expect(page).to_not have_link I18n.t('task.my')
    end
  end
end
