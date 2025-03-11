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
    resources :plannings, only: [:create, :index, :show] do
      get 'upsert_line', on: :member
    end
     
    resources :categories, only: [:index] do
      collection do
        get 'upsert'
      end
    end
    
    resources :transactions, only: [:index, :create] do
      collection do
        get 'filter_by_date', to: 'transactions#index_by_date'
        get 'filter_by_date_range', to: 'transactions#index_by_date_range'
      end
    end
  end
end
