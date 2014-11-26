class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    alias_action :create, :read, :update, :destroy, to: :crud

    if user.role? :fooda_employee
      can :manage, :homepage
      can :manage, :vendors
      can :manage, :accounts
      can :manage, :events
      can :manage, :reports
      can :read, :dashboard
      can :read, :admin_dashboard
      can :crud, :markets
      can :send, :scheduled_emails
      can [:create, :index, :update, :change_password, :csv_upload, :export_reviews, :export_bar_graph_data], :user

      if user.role? :super_admin
        can :manage, :all
      end

      if user.role? :accounting
        can :manage, :payments
      end

    else #foodizen

      can :read,   User, id: user.id
      can :update, User, id: user.id
      can :change_password, User, id: user.id

      can :add_card,    User, id: user.id
      can :update_card, User, id: user.id
      can :delete_card, User, id: user.id
      can :read_settings, Account, Account.all do |account|
        user.is_admin?(account)
      end
      can :update_settings, Account, Account.all do |account|
        user.is_admin?(account)
      end

      if user.id?
        can :toggle_favorite, MenuTemplate
      end

       can :read,   Catering::Order, user_id: user.id

      if user.role? :catering_foodizen

        can :create,  Contact
        can :update,  Contact, user_id: user.id
        can :destroy, Contact, user_id: user.id
        can :default, Contact

        can :create,  Location
        can :update,  Location, created_by_id: user.id
        can :destroy, Location, created_by_id: user.id

      end
    end
  end
end
