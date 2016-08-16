namespace :db do
  desc 'Erase and fill database with fake data'
  task populate: :environment do
    5.times do
      user = User.where(email: Faker::Internet.email).first_or_create!(
          password: Faker::Internet.password
      )
      5.times do
        user.tasks.create!(
            name: Faker::Lorem.sentence, description: Faker::Lorem.paragraphs.join(' '),
        )
      end
    end
  end
end
