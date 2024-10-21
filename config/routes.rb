Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get 'users/show', to: 'users/profile#show'

  namespace :finance do
    resources :planning_lines
    resources :plannings, only: [:create] do
      collection do
        get 'current'
      end
      post 'upsert_line', on: :member
    end
    resources :transactions, only: [:create]
    resources :categories, only: [:index] do
      collection do
        post 'upsert'
      end
    end
  end
end
