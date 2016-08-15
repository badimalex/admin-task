FactoryGirl.define do
  factory :user do
    sequence(:email) { |i| "user#{i}@test.com" }
    password Faker::Internet.password(8)
  end
end
