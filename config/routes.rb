Rails.application.routes.draw do
  root "marketing/static_pages#homepage"

  namespace :admin do
    resources :profiles, only: [:index, :show]

    root to: "dashboards#show"

    namespace :development do
      root to: "dashboards#show"

      namespace :portunus do
        root to: "dashboards#show"

        resources :kek_rotations, only: [:create]
      end
    end

    namespace :finance do
      root to: "dashboards#show"

      resources :revenue_records, only: [:index], path: :revenue
      resources :billing_features, only: [:index, :create, :new, :edit, :update]
      resources :billing_products, only: [:index, :edit, :update]
      resources :stripe_syncs, only: [:create]
    end

    namespace :support do
      root to: "dashboards#show"

      resources :companies, only: [:index, :show, :update] do
        namespace :companies, path: "" do
          resource :deletion, only: [:create]
        end
      end

      resources :members, only: [:index, :show]
      resources :support_requests, only: [:index, :show, :update, :destroy] do
        resources :support_request_messages, only: [:create]
      end
    end
  end

  scope module: :authentication, path: :auth, as: :auth do
    resources :password_authentications, only: [:new, :create]
    resources :password_confirmations, only: [:new, :create]
    resource :mobile_authenticator, only: [:update]

    resources(
      :two_factor_authentications,
      only: [:new, :create],
      path: "sources"
    )

    resources :two_factor_sessions, only: [:new, :create]

    resources :webauthn_credentials, only: [:destroy]
    resources :webauthn_credentials, format: :js, only: [:create]
  end

  # omniauth
  get "/auth/:provider/callback", to: "authentication/omniauth#create"

  namespace :ichnaea do
    resources :events, only: [:create]
  end

  # we need devise here so we can access the sign_in methods
  devise_for :members, only: []

  devise_scope :member do
    get "sign_out", to: "devise/sessions#destroy", as: :destroy_user_session
  end

  namespace :marketing do
    resources :contact_us_requests, only: [:new, :create], path: "contact-us"

    namespace :remote, defaults: { format: :js } do
      resources :beta_requests, only: :create
    end

    resources :unsubscribes, only: [:new, :create, :index]
  end

  namespace :dashboard do
    root "home#show"

    scope module: :company, path: :company, as: :company do
      resources :pending_members, only: [:index], path: "pending"
    end

    # TODO: Check me for making sure this is set up and configured correctly
    resource :notification_settings, only: [:show, :update]

    namespace :onboarding do
      resources :calendars, only: [:index]
      resources :companies, only: [:update]
      resources :company_settings, only: [:index]
      resources :introductions, only: [:index], path: "introduction"
    end

    namespace :settings do
      root "root#show"

      resources :account_deletions, only: [:create]
      resources :billings, only: [:index], path: "billing"

      namespace :billing do
        resources :downgrades, only: [:create, :update]
        resources :prices, only: [:index, :create]
        resources :invoices, only: [:show]

        resources(
          :payment_intents,
          only: [:create, :show, :update],
          path: "payments"
        )
      end

      resources :companies, only: [:index, :update], path: "company"
      resource :data_and_privacy, only: [:show]
      resources :gdpr_exports, only: [:create]
      resources :pending_members, only: [:index, :update], path: "pending"

      resources(
        :billing_sources,
        only: [:new, :create, :destroy, :update],
        path: "sources"
      )
    end

    resources(
      :profiles,
      only: [:index, :show, :new, :create],
      path: "employees"
    )

    resources :support_requests, only: [:index, :create], path: "support"
  end

  namespace :resque_web do
    resource  :overview, only: [:show], controller: :overview
    resources :working, only: [:index]
    resources :queues, only: [:index,:show,:destroy], constraints: { id: /[^\/]+/ } do
      member do
        put "clear"
      end
    end
    resources :workers, only: [:index,:show], constraints: { id: /[^\/]+/ }
    resources :failures, only: [:show,:index,:destroy] do
      member do
        put "retry"
      end
      collection do
        put "retry_all"
        delete "destroy_all"
      end
    end

    get "/stats", to: "stats#index"
    get "/stats/resque", to: "stats#resque"
    get "/stats/redis", to: "stats#redis"
    get "/stats/keys", to: "stats#keys"
    get "/stats/keys/:id", to: "stats#keys", constraints: { id: /[^\/]+/ }, as: :keys_statistic

    root to: "overview#show"
  end

  scope module: :utilities, path: :utilities, as: :utilities do
    resource :session_timezone, only: [:create]
  end

  namespace :webhooks do
    post "/sync_subscriptions/:id", to: "sync_subscriptions#update"
    post "/stripe", to: "stripes#create"
  end

  get "/about-us", to: "marketing/static_pages#about_us"
  get "/connect", to: "marketing/static_pages#connect"
  get "/homepage", to: "marketing/static_pages#homepage"
  get "/pricing", to: "marketing/static_pages#pricing"

  if !Rails.env.production?
    get "/styleguide", to: "development#styleguide"
  end
end
