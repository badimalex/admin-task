require 'rails_helper'

feature 'Create task' do
  let(:user) { create(:user) }
  let(:my_tasks) { create_list(:task, 2, user: user) }
  let(:other_tasks) { create_list(:task, 2) }

  context 'Authenticated' do
    before do
      my_tasks
      other_tasks

      sign_in user
    end

    scenario 'sees my tasks button' do
      expect(page).to have_link I18n.t('task.my')
    end

    scenario 'sees your tasks' do
      click_on I18n.t('task.my')

      within 'table.tasks' do
        my_tasks.each do |task|
          expect(page).to have_content(task.id)
          expect(page).to have_link(task.name)
          expect(page).to have_content(task.description)
          expect(page).to have_content(I18n.t('activerecord.state_machines.task.states.new'))
          expect(page).to have_content(task.created_at.strftime("%d.%m.%Y"))
        end
      end
    end

    scenario 'does not sees other user tasks' do
      click_on I18n.t('task.my')

      other_tasks.each do |task|
        expect(page).to_not have_link(task.name)
      end
    end
  end

  context 'Non-authenticated' do
    scenario 'does not sees my tasks button' do
      visit root_path
      expect(page).to_not have_link I18n.t('task.my')
    end
  end
end
