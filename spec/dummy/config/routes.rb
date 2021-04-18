Rails.application.routes.draw do
  mount RadCommon::Engine => '/rad_common'

  devise_for :users, controllers: { confirmations: 'users/confirmations', invitations: 'users/invitations' }

  resources :users, only: %i[index show edit update destroy] do
    member do
      put :resend_invitation
      put :confirm
      put :reset_authy
    end
  end

  resources :security_roles do
    get :permission, on: :collection
  end

  resources :user_security_roles, only: :show
  resources :companies, only: %i[show edit update]
  resources :divisions

  resources :attorneys do
    member do
      get :not_duplicate
      put :duplicate_do_later
      put :reset_duplicates
      patch :merge_duplicates
    end

    collection do
      get :show_current_duplicates
    end
  end

  namespace :api, defaults: { format: :json } do
    resources :divisions, only: :show
  end

  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  root to: 'pages#home'
end
