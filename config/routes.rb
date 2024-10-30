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

  get 'users/show', to: 'users/profile#show'

  namespace :finance do
    resources :planning_lines
    resources :plannings, only: [:create] do
      collection do
        get 'current'
      end
      post 'upsert_line', on: :member
    end
    resources :transactions, only: [:index, :create] do
      collection do
        get 'filter_by_date', to: 'transactions#index_by_date'
      end
    end
    resources :categories, only: [:index] do
      collection do
        post 'upsert'
      end
    end
  end
end
