Rails.application.routes.draw do
  scope module: :web do
    resource :sessions, only: [:new, :create, :destroy]
    resources :users

    scope module: :dashboard do
      root 'tasks#index'
    end
  end
end
