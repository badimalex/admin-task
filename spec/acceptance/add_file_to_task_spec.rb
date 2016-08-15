require 'rails_helper'

feature 'Add file to task' do
  let(:user) { create(:user) }

  context 'User add task with file' do
    before { sign_in user }

    scenario 'type file' do
      click_on I18n.t('task.add')
      fill_in I18n.t('activerecord.attributes.task.name'), with: 'Test task'
      fill_in I18n.t('activerecord.attributes.task.description'), with: 'Task description'

      attach_file I18n.t('activerecord.attributes.attachment.file'), "#{Rails.root}/spec/spec_helper.rb"

      click_on I18n.t('actions.submit')

      expect(page).to have_content I18n.t('task.created')
      expect(page).to have_content 'spec_helper.rb'
    end
  end
end
