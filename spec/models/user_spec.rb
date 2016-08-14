require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_uniqueness_of(:email) }

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
end
