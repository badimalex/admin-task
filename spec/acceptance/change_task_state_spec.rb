require 'rails_helper'

feature 'Switch task states' do
  let(:user) { create(:user) }
  let(:task) { create(:task, user: user) }
  let(:task_started) { create(:task, state: 'started', user: user) }

  scenario 'start' do
    task
    sign_in user
    visit my_tasks_path

    click_on I18n.t('activerecord.state_machines.task.events.start')
    expect(page).to have_content I18n.t('activerecord.state_machines.task.states.started')
    expect(page).to_not have_link I18n.t('activerecord.state_machines.task.events.start')
    expect(page).to have_link I18n.t('activerecord.state_machines.task.events.finish')
  end

  scenario 'finish' do
    task_started
    sign_in user
    visit my_tasks_path

    click_on I18n.t('activerecord.state_machines.task.events.finish')
    expect(page).to have_content I18n.t('activerecord.state_machines.task.states.finished')
    expect(page).to_not have_link I18n.t('activerecord.state_machines.task.events.finish')
  end
end
