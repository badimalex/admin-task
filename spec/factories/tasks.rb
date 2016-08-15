FactoryGirl.define do
  factory :task do
    sequence(:name) { |i| "Task name #{i}" }
    sequence(:description) { |i| "Task description #{i}" }
    user
  end

  factory :invalid_task, class: 'Task' do
    name nil
    description nil
  end
end
