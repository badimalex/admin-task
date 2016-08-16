require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of :password }
  it { should have_many(:tasks).dependent(:destroy) }

  describe '.authenticate' do
    let(:user) { create(:user) }

    context 'user already has authorization' do
      it 'returns the user' do
        user
        expect(User.authenticate(user.email, user.password)).to eq user
      end
    end

    context 'user has not authorization' do
      it 'returns nil' do
        expect(User.authenticate('wrong@user.com', '12345678')).to be_nil
      end
    end
  end

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:task) { create(:task, user: user) }

    let(:another_user) { create(:user) }
    let(:another_task) { create(:task, user: another_user) }

    it 'returns true, if is author of task' do
      expect(user).to be_author_of(task)
    end
  end
end
