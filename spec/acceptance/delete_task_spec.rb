require 'rails_helper'

feature 'Task deleting' do
  let(:user) { create(:user) }
  let(:admin) { create(:user, admin: true) }
  let(:task) { create(:task, user: user) }

  describe 'Admin delete task' do
    before do
      task
      sign_in admin
    end

    scenario 'sees link to delete task' do
      within 'table.tasks' do
        expect(page).to have_link(I18n.t('actions.delete'))
      end
    end

    scenario 'tries to delete' do
      click_on I18n.t('actions.delete')

      expect(current_path).to eq my_tasks_path
      expect(page).to have_content I18n.t('task.removed')
      expect(page).to_not have_content task.name
      expect(page).to_not have_content task.description
    end
  end

  describe 'User delete task' do
    before do
      task
      sign_in user
    end

    scenario 'sees link to delete task' do
      within 'table.tasks' do
        expect(page).to have_link(I18n.t('actions.delete'))
      end
    end

    scenario 'tries to delete' do
      click_on I18n.t('actions.delete')

      expect(current_path).to eq my_tasks_path
      expect(page).to have_content I18n.t('task.removed')
      expect(page).to_not have_content task.name
      expect(page).to_not have_content task.description
    end
  end
end
