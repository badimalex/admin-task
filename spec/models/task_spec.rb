require 'rails_helper'

RSpec.describe Task, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:state) }
  it { should validate_presence_of(:description) }
  it { should accept_nested_attributes_for :attachments }
  it { should have_states :new, :started, :finished }

  context 'a new Task' do
    it 'starts with state new' do
      expect(subject.state).to eq 'new'
    end
  end

  describe '.latest' do
    before do
      @first = create(:task, created_at: 1.day.ago)
      @last  = create(:task, created_at: 4.day.ago)
    end

    it 'should return tasks in the correct order' do
      expect(Task.latest).to eq [@first, @last]
    end
  end
end
