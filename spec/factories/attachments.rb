FactoryGirl.define do
  factory :attachment do
    file { File.open("#{Rails.root}/spec/spec_helper.rb") }
  end

  factory :attachment_img, class: 'Attachment' do
    file { File.open("#{Rails.root}/spec/fixtures/files/logo.png") }
  end
end
