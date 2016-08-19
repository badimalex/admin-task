require 'rails_helper'

RSpec.describe Web::Dashboard::TasksController, type: :controller do
  let(:task) { create(:task) }

  shared_examples_for 'public access to tasks' do
    describe 'GET #index' do
      let(:tasks) { create_list(:task, 2) }

      before { get :index }

      it 'populates an array of all tasks' do
        expect(assigns(:tasks)).to match_array(tasks)
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
    end
  end

  describe 'admin access' do
    let(:other_user) { create(:user) }

    before do
      other_user
      @user = create(:user, admin: true)
      session[:user_id] = @user.id
      allow(controller).to receive(:current_user).and_return(@user)
    end

    describe 'POST #create' do
      context 'with valid attributes' do
        it 'saves the new task in the database' do
          expect { post :create, task: attributes_for(:task).merge({user_id:other_user}) }.to change(other_user.tasks, :count).by(1)
        end
      end
    end
  end

  describe 'user access' do
    let(:task) { create(:task, user: @user, name: 'Original name', description: 'Original description') }

    before do
      @user = create(:user)
      session[:user_id] = @user.id
      allow(controller).to receive(:current_user).and_return(@user)
    end

    it_behaves_like 'public access to tasks'

    describe 'GET #new' do
      before { get :new }

      it 'assigns a new task to @task' do
        expect(assigns(:task)).to be_a_new(Task)
      end

      it 'builds new attachment for task' do
        expect(assigns(:task).attachments.first).to be_a_new(Attachment)
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

    describe 'POST #change_state' do
      it 'try to change state' do
        expect_any_instance_of(Task).to receive(:change_state)
        post :change_state, id: task
      end

      it 'redirect to #my_tasks_path' do
        post :change_state, id: task
        expect(response).to redirect_to my_tasks_path
      end
    end

    describe 'GET #edit' do
      context 'when user is owner' do
        before { get :edit, id: task }

        it 'assigns the requested task to @task' do
          expect(assigns(:task)).to eq task
        end

        it 'renders the :edit template' do
          expect(response).to render_template :edit
        end
      end

      context 'when user is not the owner' do
        let(:another_user) { create(:user) }
        let(:another_task) { create(:task, user: another_user) }

        it 'redirect to root_path' do
          get :edit, id: another_task
          expect(response).to redirect_to root_path
        end
      end
    end

    describe 'PATCH #update' do
      context 'with valid attributes' do
        it 'assigns the task post to @task' do
          patch :update, id: task, task: attributes_for(:task)
          expect(assigns(:task)).to eq task
        end

        it 'updates task in the database' do
          patch :update, id: task, task: { name: 'new name', description: 'new description' }
          task.reload
          expect(task.name).to eq 'new name'
          expect(task.description).to eq 'new description'
        end

        it 'redirects to the updated task' do
          patch :update, id: task, task: attributes_for(:task)
          expect(response).to redirect_to task
        end
      end

      context 'with invalid attributes' do
        before { patch :update, id: task, task: attributes_for(:invalid_task) }

        it 'does not update task' do
          task.reload
          expect(task.name).to eq 'Original name'
          expect(task.description).to eq 'Original description'
        end

        it 'redirects to the #edit' do
          expect(response).to redirect_to edit_task_path(task)
        end
      end

      context 'when not the owner' do
        let(:another_user) { create(:user) }
        let(:another_task) { create(:task, user: another_user, description: 'Original description') }

        it "doesn't update task" do
          another_task
          patch :update, id: another_task, post: { name: 'new name', description: 'new description' }

          another_task.reload
          expect(another_task.description).to eq 'Original description'
        end
      end
    end

    describe 'Delete #destroy' do
      context 'Author deletes own task' do
        it 'deletes post' do
          task
          expect { delete :destroy, id: task }.to change(@user.tasks, :count).by(-1)
        end
        it 'redirect to my_tasks_path' do
          delete :destroy, id: task
          expect(response).to redirect_to my_tasks_path
        end
      end

      context 'Author deletes another author task' do
        let(:another_user) { create(:user) }
        let(:another_task) { create(:task, user: another_user) }

        it "doesn't deletes a task" do
          another_task
          expect { delete :destroy, id: another_task }.to_not change(Task, :count)
        end

        it 'redirect to root_path' do
          delete :destroy, id: another_task
          expect(response).to redirect_to root_path
        end
      end
    end
  end

  describe 'guest access' do
    it_behaves_like 'public access to tasks'

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

    describe 'POST #change_state' do
      it 'redirects to login' do
        post :change_state, id: task
        expect(response).to redirect_to new_sessions_path
      end
    end

    describe 'GET #show' do
      before { get :show, id: task }

      it 'assigns the requested task to @task' do
        expect(assigns(:task)).to eq task
      end
    end

    describe 'GET #edit' do
      it 'redirects to login' do
        get :edit, id: task
        expect(response).to redirect_to(new_sessions_path)
      end
    end

    describe 'DELETE #destroy' do
      it 'redirects to login' do
        delete :destroy, id: create(:task)
        expect(response).to redirect_to(new_sessions_path)
      end
    end
  end
end
