Rails
  .application
  .routes
  .draw do
    root 'foods#index'
    get 'login', to: 'user_sessions#new'
    post 'login', to: 'user_sessions#create'
    delete 'logout', to: 'user_sessions#destroy'

    resources :users, only: %i[index new create show]

    resources :foods do
      collection { match :mymenu_new, to: 'foods#mymenu_new', via: %i[get post] }
    end
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  end
