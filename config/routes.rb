Rails
  .application
  .routes
  .draw do
    root 'foods#index'
    get 'login', to: 'user_sessions#new'
    post 'login', to: 'user_sessions#create'
    delete 'logout', to: 'user_sessions#destroy'

    resources :users, only: %i[index new create show]

    resources :mymenus
    resources :foods
    resources :eatdate_likes, only: %i[create delete]
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  end
