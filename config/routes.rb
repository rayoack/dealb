# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'

  devise_for(
    :users,
    path: '',
    path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      confirmation: 'users/confirmations',
      unlock: 'unlock',
      registration: '',
      sign_up: 'signup'
    },
    controllers: {
      omniauth_callbacks: 'users/omniauth_callbacks',
      registrations: 'users/registrations',
      confirmations: 'users/confirmations',
      sessions: 'users/sessions',
      passwords: 'users/passwords'
    }
  )

  resources :companies, only: %i[index new create show edit update destroy] do
    collection do
      get :names, action: :names
      get :locations, action: :locations
    end

    member do
      get :widget
    end
  end

  resources :deals, only: %i[index new create show edit update destroy] do
    post 'index', action: 'create'
  end

  resources :people, only: %i[index new create show edit update destroy]

  resources :investors, only: %i[index show edit update destroy] do
    collection do
      get :ranking, action: :ranking
    end
  end

  resources :users, only: %i[index] do
    get 'block', action: 'block'
    get 'unblock', action: 'unblock'

    get 'become_user', action: 'become_user'
    get 'become_admin', action: 'become_admin'
    get 'become_moderator', action: 'become_moderator'
  end

  resources :markets, only: %i[index new create edit update]

  namespace :api do
    resources :companies, only: [] do
      member do
        get :info
      end
    end
  end

  get :search, to: 'search#index'
  get :contact, to: 'contacts#index'
  post :contact, to: 'contacts#create'
  get :developer, to: 'developers#index'
  get :embassador, to: 'embassador#index'
  get :faq, to: 'faq#index'
  get :about, to: 'about#index'

  get :sitemap, to: 'sitemap#index'
end
