require 'rails_helper'

RSpec.describe Web::Dashboard::MyTasksController, type: :controller do
  describe 'user access' do
    before do
      @user = create(:user)
      session[:user_id] = @user.id
      allow(controller).to receive(:current_user).and_return(@user)
    end

    describe 'GET #index' do
      let(:tasks) { create_list(:task, 2, user: @user) }
      let(:other_tasks) { create_list(:task, 2) }

      before do
        tasks
        other_tasks
        get :index
      end

      it 'populates an array of all task' do
        expect(assigns(:tasks)).to match_array(tasks)
      end

      it 'not include in array other user task' do
        expect(assigns(:tasks)).to_not include(other_tasks)
      end

      it 'renders index view' do
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
