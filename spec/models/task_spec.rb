require 'rails_helper'

RSpec.describe Task, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:attachments) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
  it { should accept_nested_attributes_for :attachments }
end
