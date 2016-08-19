require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest'do
    let(:user) { nil }

    it { should be_able_to :read, Task }
    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }
    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }
    it { should be_able_to :create, Task }
    it { should_not be_able_to :create, create(:task, user: other), user: user }

    it { should be_able_to :update, create(:task, user: user), user: user }
    it { should_not be_able_to :update, create(:task, user: other), user: user }

    it { should be_able_to :destroy, create(:task, user: user), user: user }
    it { should_not be_able_to :destroy, create(:task, user: other), user: user }

    it { should be_able_to :change_state, create(:task, user: user), user: user }
    it { should_not be_able_to :change_state, create(:task, user: other), user: user }
  end
end
