require 'rails_helper'

RSpec.describe Web::Dashboard::TasksController, type: :controller do
  describe 'user access' do
    before do
      @user = create(:user)
      session[:user_id] = @user.id
      allow(controller).to receive(:current_user).and_return(@user)
    end

    describe 'GET #new' do
      before { get :new }

      it 'assigns a new task to @task' do
        expect(assigns(:task)).to be_a_new(Task)
      end

      it 'renders the :new template' do
        expect(response).to render_template :new
      end
    end

    describe 'POST #create' do
      context 'with valid attributes' do
        it 'saves the new task in the database' do
          expect { post :create, task: attributes_for(:task) }.to change(@user.tasks, :count).by(1)
        end

        it 'redirect to show view' do
          post :create, task: attributes_for(:task)
          expect(response).to redirect_to task_path(assigns(:task))
        end
      end

      context 'with invalid attributes' do
        it 'does not save the task' do
          expect { post :create, task: attributes_for(:invalid_task) }.to_not change(Task, :count)
        end

        it 're-renders the :new template' do
          post :create, task: attributes_for(:invalid_task)
          expect(response).to render_template :new
        end
      end
    end
  end

  describe 'guest access' do
    describe 'GET #new' do
      it 'redirect to sign in' do
        get :new
        expect(response).to redirect_to new_sessions_path
      end
    end

    describe 'POST #create' do
      it 'redirects to login' do
        post :create, task: attributes_for(:task)
        expect(response).to redirect_to new_sessions_path
      end
    end
  end
end
