Rails
  .application
  .routes
  .draw do
    root 'users#new'
    get 'login', to: 'user_sessions#new'
    post 'login', to: 'user_sessions#create'
    delete 'logout', to: 'user_sessions#destroy'

    resources :users, only: %i[index new create show]
    resources :posts

    resources :foods do
      collection { match :confirm, to: 'foods#confirm', via: %i[get post] }
    end
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  end
