require 'rails_helper'

feature 'Task editing' do
  let(:user) { create(:user) }
  let(:task) { create(:task, user: user) }
  let(:another_task) { create(:task, user: create(:user)) }

  describe 'User edit task' do
    before do
      task
      sign_in user
    end

    scenario 'sees link to edit task' do
      within 'table.tasks' do
        expect(page).to have_link(I18n.t('actions.edit'))
      end
    end

    scenario 'with valid data' do
      click_on I18n.t('actions.edit')

      fill_in I18n.t('activerecord.attributes.task.name'), with: 'Edited task'
      fill_in I18n.t('activerecord.attributes.task.description'), with: 'Edited description'

      click_on I18n.t('actions.submit')

      expect(current_path).to eq task_path(task)
      expect(page).to_not have_content task.name
      expect(page).to_not have_content task.description
      expect(page).to have_content 'Edited task'
      expect(page).to have_content 'Edited description'
      expect(page).to_not have_selector 'textarea'
    end

    scenario 'with invalid data' do
      click_on I18n.t('actions.edit')

      fill_in I18n.t('activerecord.attributes.task.name'), with: nil
      fill_in I18n.t('activerecord.attributes.task.description'), with: nil
      click_on I18n.t('actions.submit')

      expect(current_path).to eq edit_task_path(task)
      expect(page).to have_content task.description
      expect(page).to have_selector 'textarea'
    end
  end

  scenario 'User try to edit other user task' do
    sign_in user
    another_task

    visit edit_task_path(another_task)

    expect(current_path).to eq root_path
    expect(page).to have_content I18n.t('errors.non_owner')
  end
end
