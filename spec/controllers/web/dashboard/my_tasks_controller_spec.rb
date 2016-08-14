require 'rails_helper'

RSpec.describe Web::Dashboard::MyTasksController, type: :controller do
  describe 'user access' do
    before do
      @user = create(:user)
      session[:user_id] = @user.id
      allow(controller).to receive(:current_user).and_return(@user)
    end

    describe 'GET #index' do
      before { get :index }

      it 'renders the :new template' do
        expect(response).to render_template :index
      end
    end
  end

  describe 'guest access' do
    describe 'GET #index' do
      it 'redirect to sign in' do
        get :index
        expect(response).to redirect_to new_sessions_path
      end
    end
  end
end
