FactoryGirl.define do
  factory :task do
    name "MyString"
    description "MyText"
    user
  end

  factory :invalid_task, class: 'Task' do
    name nil
    description nil
  end
end
