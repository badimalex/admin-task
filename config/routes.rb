Rails.application.routes.draw do
  scope module: :web do
    resource :sessions, only: [:new, :create, :destroy]
    resources :users

    scope module: :dashboard do
      root 'tasks#index'
      resources :tasks do
        member do
          post :change_state
        end
      end
      resources :my_tasks
    end
  end
end
