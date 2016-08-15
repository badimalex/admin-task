require 'rails_helper'

feature 'List tasks' do
  let(:tasks) { create_list(:task, 2) }

  scenario 'User can view list of tasks' do
    tasks
    visit tasks_path

    within 'table.tasks' do
      tasks.each do |task|
        expect(page).to have_content(task.id)
        expect(page).to have_content(task.created_at.strftime("%d.%m.%Y"))
        expect(page).to have_link(task.name)
        expect(page).to have_content(task.user.email)
      end
    end
  end

  scenario 'User can view empty list of tasks' do
    visit tasks_path
    expect(page).to have_content('Is no tasks')
  end
end
