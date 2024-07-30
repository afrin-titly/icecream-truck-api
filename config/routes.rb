Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'sessions',
    registrations: 'registrations'
  }

  devise_scope :user do
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'
    post 'signup', to: 'registrations#create'
  end

  get '/sale', to: 'sales#total_sale', as: 'sale'
  post '/purchase', to: 'sales#purchase', as: 'purchase'
  resources :flavors
  resources :sales
  resources :items, only: [:index, :show, :create, :update, :destroy]
  resources :categories

  # match '*path', to: 'application#route_not_found', via: :all
end
