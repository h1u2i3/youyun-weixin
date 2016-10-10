require 'sidekiq/web'

class ManagerConstraint
  def matches?(request)
    request.session[:admin_id].present?
  end
end

Rails.application.routes.draw do

  resource :wechat, only: [:show, :create]
  resource :doctor, only: [:show, :create]

  namespace :weixin, path: '/' do
    constraints subdomain: 'weixin' do

      root 'page#index'
      get '/frq', to: 'page#frq'
      resource :profile, only: :show
      resources :doctors, only: [:index, :show] do
        post :search, on: :collection
      end
      scope only: :index do
        [:departments, :hospitals, :skills, :grades, :tags, :comments].each do |value|
          resources value
        end
      end
      resources :comments, only: :index
      resources :ratings, only: :index
      resources :appointments do
        post :notify, :pay, on: :collection
        post :cancel, on: :member
        get :status, :detail, on: :member
        resources :comments, only: [:new, :create] do
          get :thank, on: :collection
        end
        resources :ratings, only: [:new, :create] do
          get :thank, on: :collection
        end
      end
    end
  end

  namespace :doctor, path: '/' do
    constraints subdomain: 'doctor' do
      root 'page#index'
      get 'sign', to: 'page#sign'
      resources :calenders do
        get :single_day, :cancel, on: :collection
        get :new_batch, on: :collection
        post :create_batch, on: :collection
      end
      resources :goods do
        get :cancel, on: :collection
      end
      resources :clinics, only: [:index, :create] do
        get :manual, on: :collection
        post :identify, on: :collection
      end
      resource :profile, only: :show
    end
  end

  namespace :manage do
    root 'dashboards#show'
    get 'login', to: 'sessions#index'
    post 'login', to: 'sessions#create'
    get 'logout', to: 'sessions#destroy'
    resource :dashboard, only: :show

    namespace :baseinfo do
      get 'doctor', to: 'pages#doctor'
      get 'project', to: 'pages#project'
      scope only: [:create, :destroy] do
        [:departments, :hospitals, :skills, :grades, :tags].each do |value|
          resources value
        end
      end
    end

    resources :admins
    resources :doctors, except: :show do
      collection do
        post :detail_search
        get :search, :detail
        get :calenders, to: 'calenders#index'
        get :goods, to: 'goods#index'
      end
      post :publish, on: :member
    end
    resources :appraises do
      post :ban, on: :member
    end
    resources :appointments do
      post :refund, :remind, on: :member
    end
    resources :users, only: [:index, :destroy] do
      collection do
        post :detail_search
        get :search, :detail
      end
    end
    resources :payments
    resources :wechats, only: [:index, :show] do
      get :info, :message, :service, on: :collection
    end
    resources :calenders, except: :show do
      post :publish, on: :member
    end
    resources :goods, except: :show do
      post :publish, on: :member
    end
    resources :predoctors, only: [:index, :destroy]

    mount Sidekiq::Web, at: '/sidekiq', constraints: ManagerConstraint.new
  end

  mount ActionCable.server => '/cable'
  root 'welcome#index'
  match '*path', via: :all, to: 'welcome#not_found'
end
