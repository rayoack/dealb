# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'

  devise_for(
    :users,
    path: '',
    path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      confirmation: 'confirmation',
      unlock: 'unlock',
      registration: '',
      sign_up: 'signup'
    },
    controllers: {
      omniauth_callbacks: 'users/omniauth_callbacks'
    }
  )

  resources :companies, only: %i[index new create show edit update]
  resources :deals, only: %i[index new show update edit]
  resources :people, only: %i[index new create show edit update]
  resources :investors, only: %i[index show]
  resources :users, only: %i[index] do
    get 'block', action: 'block'
    get 'unblock', action: 'unblock'

    get 'become_user', action: 'become_user'
    get 'become_admin', action: 'become_admin'
    get 'become_moderator', action: 'become_moderator'
  end
  resources :markets, only: %i[index new create edit update]

  get :search, to: 'search#index'
  get :contact, to: 'contacts#index'
  post :contact, to: 'contacts#create'
  get :developer, to: 'developers#index'
  get :embassador, to: 'embassador#index'
  get :faq, to: 'faq#index'
  get :about, to: 'about#index'
end
