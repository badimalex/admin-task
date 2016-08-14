require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'user access' do
    before do
      @user = create(:user)
      session[:user_id] = @user.id
      allow(controller).to receive(:current_user).and_return(@user)
    end

    describe 'GET #new' do
      it 'redirect to root_path' do
        get :new
        expect(response).to redirect_to root_path
      end
    end

    describe 'POST #create' do
      before do
        post :create, user: {email: 'other@user.com', password: '12345678', password_confirmation: '12345678'}
      end

      it 'redirects to root_path' do
        expect(response).to redirect_to root_path
      end

      it 'does not update session[:user_id]' do
        expect(session[:user_id]).to eq @user.id
      end
    end
  end

  describe 'guest access' do
    describe 'GET #new' do
      before { get :new }

      it 'assigns a new user to @user' do
        expect(assigns(:user)).to be_a_new(User)
      end

      it 'renders the :new template' do
        expect(response).to render_template :new
      end
    end

    describe 'POST #create' do
      context 'with valid attributes' do
        it 'saves the new user in the database' do
          expect { post :create, user: {email: 'new@user.com', password: '12345678', password_confirmation: '12345678'}}.to \
          change(User, :count).by(1)
        end

        it 'redirect to root_path' do
          post :create, user: {email: 'new@user.com', password: '12345678', password_confirmation: '12345678'}
          expect(response).to redirect_to root_path
        end

        it 'set session[:user_id]' do
          expect(session[:user_id]).to eq User.find_by_email('new@user.com')
        end
      end

      context 'with invalid attributes' do
        it 'does not save the user' do
          expect { post :create, user: {email: nil, password: nil, password_confirmation: nil}}.to_not \
          change(User, :count)
        end

        it 're-renders the #new template' do
          post :create, user: {email: nil, password: nil, password_confirmation: nil}
          expect(response).to render_template :new
        end
      end
    end
  end
end
