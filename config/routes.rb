SnapPea::Application.routes.draw do
  require 'sidekiq/web'
  require 'sidetiq/web'

  mount Api => '/'

  authenticate :user, lambda { |u| u.role?(:super_admin)} do
    mount Sidekiq::Web => '/sidekiq'
  end

  constraints(CateringSubdomain) do
    mount Catering::Engine, at: "/"
  end


  # Global Resources
  resources :account_roles, only: [:create, :update, :destroy]
  resources :capacities, only: [:create, :update]
  resources :homepage, only: :index
  resources :menu_level_discounts, except: [:index, :show]
  resources :pricing_tiers
  resources :reports, only: :index
  resources :reviews_rollups, only: [:index, :show]
  resources :tokens, only: :show

  resources :locations, except: [:index] do
    resources :assets, only: [:index, :create, :destroy] do
      put :set_default
    end

    resources :location_documents, only: [:create, :destroy] do
      member do
        get :download
      end
    end
  end

  resources :issues, except: [:edit, :new, :destroy] do
    member do
      get :toggle
    end

    resources :comments, only: [:create]
  end

  resources :assets, only: [:index, :create, :destroy] do
    member do
      put :set_default
    end
  end

  resources :option_groups, only: [] do
    member do
      post :toggle_favorite
    end
  end

  resources :billing_references, except: :index do
    member do
      get :get_choices
    end
  end

  resources :select_events do
    resources :select_event_billing_references, only: [:create, :update, :destroy]
    resources :select_event_vendors, except: [:index, :edit]
    resources :issues, except: [:edit, :new, :destroy] 
    put :update_campaign
    get :campaign_table
  end

  resources :inventory_items do
    resources :assets
  end

  resources :menu_templates do
    resources :assets
  end

  resources :buildings, except: :index do
    resources :assets
    resources :building_documents, only: [:create, :destroy] do
      member do
        get :download
      end
    end
  end

  resources :default_billing_references, only: [] do
    collection do
      post :build_defaults
    end
  end




  # Accounts
  resources :accounts do
    member do
      get :export_events
      get :export_item_reviews
      get :export_event_reviews
      get :export_presentation_reviews
      get :export_bar_graph_data
      put :associate_users
    end

    resources :account_preferences, except: [:index]
    resources :billing_references
    resources :event_schedules, except: [:index]
    resources :issues, except: [:edit, :new, :destroy] 
    resources :select_event_schedule_billing_references, except: [ :index, :show, :edit, :new ]
    resources :select_event_schedule_vendors
    resources :select_event_schedules

    resources :contacts, except: [:index] do
      member do
        put :restore
      end
    end

    resources :locations, except: [:index] do
      member do
        put :restore
      end
    end
  end



  # Events
  resources :events do
    post :send_feedback_email
    get :event_documents

    member do
      get :fetch_cards
      get :generate
      get :reload_site_notes
      post :duplicate_event
      post :new_card
      post :update_transaction_method
      put :claim_event
      put :update_reviews
    end

    resources :billing_references
    resources :issues, except: [:edit, :new, :destroy] 
    resources :cards

    resources :event_vendors do
      member do
        post :change_grouped_menu_template_selections
      end
    end

    resources :line_items do
      get :new_menu_item, only: [:new]
    end

    resources :event_transaction_method do
      member do
        put :update_card
      end
    end

    resources :transactions do
      collection do
        post :refund
        post :settle
        post :void
      end
    end
  end



  # Vendor resources
  resources :vendors do
    collection do
      get :get_vendors_by_cuisine_and_product_and_location_and_account
      get :get_vendors_by_cuisine_and_product_and_market_and_account
    end

    member do
      get :export_bar_graph_data
      get :export_event_reviews
      get :export_events
      get :export_item_reviews
      get :export_presentation_reviews
      get :export_reviews
      get :get_vendor_menu_templates
      get :get_vendor_menu_templates_by_product
      post :toggle_favorite
    end

    resources :issues, except: [:edit, :new, :destroy] 
    resources :assets
    resources :vendor_preferences, except: [:index]

    resources :contacts, except: [:index] do
      member do
        put :restore
      end
    end

    resources :inventory_items, except: [:show, :index] do
      member do
        post :create_option_group
        post :delete_option_group
        post :update_option_group
      end
    end

    resources :vendor_insurances do
      resources :vendor_documents do
        member do
          get :download
        end
      end
    end

    resources :menu_templates, except: [:show] do
      member do
        post :change_inventory_items
        post :create_menu_group
        post :delete_menu_group
        post :toggle_favorite
      end

      resources :menu_template_groups, only: :toggle_favorite do
        member do
          post :toggle_favorite
        end
      end
    end
  end



  # Admin
  namespace :admin do
    root to: 'dashboard#index'

    match 'mailer(/:action(/:id(.:format)))' => 'mailer#:action' # Action Mailer Testing

    resources :account_pricing_tiers
    resources :delivery_groups, except: [:index, :show]
    resources :emails, except: [:index, :show]
    resources :general_reports
    resources :global_settings, only: [:create]
    resources :managed_services_reports
    resources :markets, except: [:index]
    resources :ms_bills, only: [:index]
    resources :ms_invoices, only: [:index]

    resources :billing_reference_reports do
      collection do
        get :export_billing_references
      end
    end

    resources :buildings, except: [:index] do
      get :new_with_account, only: [:new]
      resources :asset
    end

    resources :vouchers, only: :index do
      put 'redeem_voucher', on: :member
      put 'redeem_all_vouchers', on: :collection
    end

    resources :users do
      collection do
        post :csv_upload
      end

      member do
        get :export_bar_graph_data
        get :export_reviews
        get :password_reset
        get :resend_welcome_email
        put :change_password
        put :restore_user
      end
    end
  end

  namespace :select do
    resources :select_orders do
      resources :select_order_items, only: [:new, :create, :update, :destroy]
      get 'new_inventory_item/:id', to: 'select_order_items#new_inventory_item'
      get 'new_transaction', to: 'select_orders#new_transaction', as: :new_transaction
      post 'adjust', to: 'select_orders#adjust', as: :adjust

      resources :select_order_transactions, only: [:new, :create] do
        get 'refund', to: 'select_order_transactions#refund', as: :refund
      end
    end
  end

  resources :buildings, except: [:index] do
    resources :assets
    resources :building_documents do
      member do
        get :export_bar_graph_data
        get :export_reviews
        get :password_reset
        get :resend_welcome_email
        put :change_password
        put :restore_user
      end
    end
  end


  # Devise (User routes)
  devise_for :users, controllers: {
    passwords:     "users/passwords",
    registrations: "users/registrations",
    sessions:      "users/sessions"
  }, skip: [:registrations]


  devise_scope :user do
    # Devise Routes for catering login/logout/forgot/recover password
    constraints(CateringSubdomain) do
      get :login,            to: 'users/sessions#catering_new',      as: :catering_login
      get :logout,           to: 'users/sessions#catering_logout',   as: :catering_logout
      get :forgot_password,  to: 'users/passwords#catering_forgot',  as: :catering_forgot_password
      get :recover_password, to: 'users/passwords#catering_recover', as: :catering_recover_password
      put :update_password,  to: 'users/passwords#catering_update',  as: :catering_update_password
    end

    # Devise Routes for SnapPea register/login/logout
    get :login,  to: 'devise/sessions#new',     as: :login
    get :logout, to: 'devise/sessions#destroy', as: :logout
  end


  get "/search.html", to: "search#index"
  get '/404', to: 'errors#not_found'
  get '/500', to: 'errors#server_error'

  root to: "homepage#index"
end
