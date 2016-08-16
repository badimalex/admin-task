require 'rails_helper'

feature 'View task' do
  let(:user) { create(:user) }
  let(:admin) { create(:user, admin: true) }
  let(:task) { create(:task) }
  let(:task_with_image) { create(:task) }

  scenario 'User' do
    task
    sign_in user

    visit tasks_path
    click_on task.name

    expect(page).to have_content(task.id)
    expect(page).to have_content(task.name)
    expect(page).to have_content(task.description)
    expect(page).to have_content(task.created_at.strftime("%d.%m.%Y"))
    expect(page).to_not have_content(task.user.email)
  end

  scenario 'Admin' do
    task
    sign_in admin

    visit tasks_path
    click_on task.name

    expect(page).to have_content(task.id)
    expect(page).to have_content(task.name)
    expect(page).to have_content(task.description)
    expect(page).to have_content(task.created_at.strftime("%d.%m.%Y"))
    expect(page).to have_content(task.user.email)
  end

  context 'With attachments' do
    before do
      sign_in user
    end

    scenario 'type file' do
      task.attachments<<create(:attachment)
      visit tasks_path
      click_on task.name
      expect(page).to have_content("#{task.attachments.first.file.identifier}")
    end

    scenario 'type image' do
      task_with_image.attachments<<create(:attachment_img)
      visit tasks_path
      click_on task_with_image.name
      expect(page).to have_css("img[src*='#{task_with_image.attachments.first.file}']")
    end
  end
end
