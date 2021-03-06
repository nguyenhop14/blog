Rails.application.routes.draw do

  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "/help", to: "static_pages#help"
    get "/about", to: "static_pages#about"
    get "/contact", to: "static_pages#contact"
    get "/signup", to: "users#new"
    get "/login", to: "sessions#new"
    get "sessions/new"
    get "/auth/facebook", to: "sessions#create"
    get "auth/failure", to: "sessions#failure"

    post "/login", to: "sessions#create"
    post "/signup", to: "users#create"

    delete "/logout", to: "sessions#destroy"

    resources :users do
      member do
        get :following, :followers
      end
    end
    resources :entries do
      resources :comments
    end
    resources :relationships, only: [:create, :destroy]
    resources :comments
  end
end
