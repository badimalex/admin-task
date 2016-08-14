require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'user access' do
    before do
      @user = create(:user)
      session[:user_id] = @user.id
      allow(controller).to receive(:current_user).and_return(@user)
    end

    describe 'POST #create' do
      it 'redirects to root_path' do
        post :create, user: {email: 'other@user.com', password: '123'}
        expect(response).to redirect_to root_path
      end
    end

    describe 'Delete #destroy' do
      before do
        delete :destroy
      end

      it 'destroy session[:user_id]' do
        expect(session[:user_id]).to be_nil
      end

      it 'redirect to index view' do
        expect(response).to redirect_to root_path
      end
    end

    describe 'GET #new' do
      it 'redirect to root_path' do
        get :new
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'guest access' do
    describe 'GET #new' do
      it 'renders the :new template' do
        get :new
        expect(response).to render_template :new
      end
    end

    describe 'DELETE #destroy' do
      it 'redirect to login' do
        delete :destroy
        expect(response).to redirect_to new_session_path
      end
    end

    describe 'POST #create' do
      let(:user) { create(:user) }

      it 'try to authenticate user' do
        user
        expect(User).to receive(:authenticate).with(user.email, user.password)
        post :create, user: attributes_for(:user)
      end

      context 'with valid attributes' do
        before do
          user
          post :create, user: attributes_for(:user)
        end

        it 'redirect to show view' do
          expect(response).to redirect_to root_path
        end

        it 'set session[:user_id]' do
          expect(session[:user_id]).to eq user.id
        end
      end

      context 'with invalid attributes' do
        it 'renders #new template' do
          post :create, user: attributes_for(:user)
          expect(response).to redirect_to new_session_path
        end
      end
    end
  end
end
