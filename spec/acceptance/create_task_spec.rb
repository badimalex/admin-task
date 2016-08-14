require 'rails_helper'

feature 'Create task' do
  let(:user) { create(:user) }

  context 'User creates a task' do
    before { sign_in user }
    scenario 'with valid attributes' do
      click_on I18n.t('task.add')
      fill_in I18n.t('activerecord.attributes.task.name'), with: 'Test task'
      fill_in I18n.t('activerecord.attributes.task.description'), with: 'Task description'

      click_on I18n.t('actions.submit')

      expect(page).to have_content I18n.t('task.created')
    end

    scenario 'with invalid attributes' do
      click_on I18n.t('task.add')
      fill_in I18n.t('activerecord.attributes.task.name'), with: nil
      fill_in I18n.t('activerecord.attributes.task.description'), with: nil

      click_on I18n.t('actions.submit')
      expect(page).to have_content "#{I18n.t('activerecord.attributes.task.name')} #{I18n.t('errors.messages.blank')}"
      expect(page).to have_content "#{I18n.t('activerecord.attributes.task.description')} #{I18n.t('errors.messages.blank')}"
    end
  end
end
