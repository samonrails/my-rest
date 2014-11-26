# == Schema Information
#
# Table name: users
#
#  id                          :integer          not null, primary key
#  email                       :string(255)      default(""), not null
#  encrypted_password          :string(255)      default(""), not null
#  reset_password_token        :string(255)
#  reset_password_sent_at      :datetime
#  remember_created_at         :datetime
#  sign_in_count               :integer          default(0)
#  current_sign_in_at          :datetime
#  last_sign_in_at             :datetime
#  current_sign_in_ip          :string(255)
#  last_sign_in_ip             :string(255)
#  confirmation_token          :string(255)
#  confirmed_at                :datetime
#  confirmation_sent_at        :datetime
#  unconfirmed_email           :string(255)
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  first_name                  :string(40)
#  last_name                   :string(40)
#  disable                     :boolean          default(FALSE)
#  created_by                  :string(255)
#  default_account_location_id :integer
#  default_billing_id          :integer
#  default_contact_id          :integer
#  roles_mask                  :integer
#  deleted_at                  :datetime
#  payment_method              :string(255)
#  default_account_id          :integer
#  phone_number                :string(255)
#  position                    :string(255)
#  agreed_terms_at             :datetime
#  utility_account             :boolean          default(FALSE)
#

class User < ApplicationModel
  include SearchSortPaginate
  acts_as_paranoid
  
  devise :database_authenticatable, 
    :registerable, 
    :confirmable,
    :recoverable, :rememberable, :trackable, :validatable,
    :authentication_keys => [:email]

  has_many :documents, :foreign_key => 'creator_id'
  has_many :vendor_documents, :dependent => :destroy
  has_many :vendor_insurances, :dependent => :destroy
  has_many :assigned_issues, foreign_key: 'assignee_id', class_name: 'Issue'
  has_many :reported_issues, foreign_key: 'assigner_id', class_name: 'Issue'
  has_many :comments
  has_many :cards
  has_many :account_roles, dependent: :destroy
  has_many :accounts, through: :account_roles
  has_many :locations, through: :accounts
  has_many :buildings, through: :locations
  has_many :building_documents, :dependent => :destroy
  has_many :location_documents, :dependent => :destroy
  has_one  :braintree_account, :as => :resource
  has_and_belongs_to_many :menu_templates
  has_many :default_billing_references, :dependent => :destroy
  has_many :delivery_groups, dependent: :destroy

  has_many :billings, class_name: "Catering::Billing"
  has_many :contacts
  has_many :events, foreign_key: 'event_owner_id', class_name: 'Event'
  has_many :event_schedules, foreign_key: 'event_schedule_owner_id', class_name: 'EventSchedule'

  validates :email, :uniqueness => true
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates :created_by, inclusion: { in: %w(self admin admin_batch fooda_rake), message: "can be self/admin/admin_batch/fooda_rake only"}, allow_nil: true

  scope :with_role, lambda { |role| {:conditions => ["roles_mask & ? > 0", 2**ROLES.index(role.to_s) ], :order => [:first_name, :last_name]} }

  after_create :set_braintree_account
  after_create :create_self_contact

  # NOTE! The roles translate to a bitmask, so if you add roles you have to add them
  # to the end of the array so you don't mess up the current roles bit stuff. 
  ROLES = %w[super_admin fooda_employee accounting catering_foodizen foodizen]

    
  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
  end
  
  def roles
    ROLES.reject { |r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }
  end

  def role?(role)
    role_symbols.include? role
  end
  
  def role_symbols
    roles.map(&:to_sym)
  end

  # Define class method for each role so as to fetch objects having specific role e.g User.fooda_employee
  ROLES.each do |role|
    define_singleton_method(role) do
      with_role role
    end
  end

  def self.default_search_fields parent_model=nil
    [
      { :name => :email, :as => :string, :wildcard => :both },
    ]
  end

  def self.all_possible_search_fields parent_model=nil
    [
      { :name => :email, :as => :string, :wildcard => :both },
      { :name => :account, :as => :string, :wildcard => :both },
      { :name => :last_name, :as => :string, :wildcard => :both },
    ]
  end

  def to_s
    name
  end

  def full_name    
    [first_name, last_name].reject(&:nil?).join(' ') if first_name and last_name
  end

  alias :name :full_name

  [["opened", false],["closed", true]].each do |meth|
    define_method("#{meth[0]}_assigned_issues") do
      assigned_issues.select {|i| i.status == meth[1]}
    end
  end

  [["opened", false],["closed", true]].each do |meth|
    define_method("#{meth[0]}_reported_issues") do
      reported_issues.select {|i| i.status == meth[1]}
    end
  end

  def set_braintree_account
    self.build_braintree_account.save
  end

  def braintree_identity
    braintree_account.braintree_id if braintree_account
  end

  def self.import(file, send_email, associated_accounts, system_roles = %w[catering_foodizen foodizen])
    created_count = 0
    failure_count = 0
    CSV.foreach(file.path, headers: true) do |row|
      user = User.new row.to_hash
      user.password = (0...8).map{(65+rand(26)).chr}.join
      temporary_password = user.password
      user.reset_password_token = User.reset_password_token
      user.reset_password_sent_at = Time.now
      user.created_by = "admin_batch"
      user.roles = system_roles
      user.skip_confirmation!
      user.skip_reconfirmation!
      if user.save
        created_count += 1
        Sidekiq::Client.enqueue(MailScheduler, user.id, temporary_password, "Force Send") if send_email
        associated_accounts.each do |account|
          user.account_roles.create(account: account)
        end
      else
        failure_count += 1
        next
      end
    end
    return created_count, failure_count
  end

  def admin_build system_roles
    self.roles = system_roles || %w[catering_foodizen foodizen]
    self.created_by = "admin"
    self.password = (0...8).map{(65+rand(26)).chr}.join
    self.reset_password_token = User.reset_password_token
    self.reset_password_sent_at = Time.now
    self.skip_confirmation!
    self.skip_reconfirmation!
  end

  def admin_save associated_accounts, skip_welcome_email
    associated_accounts.each { |account| self.account_roles.create(account: account) }
    Sidekiq::Client.enqueue(MailScheduler, self.id, self.password, "Force Send") unless skip_welcome_email
  end

  # after_email_confirmation callback
  def confirm!
    super
  end

  def active_for_authentication?
    super and !self.utility_account?
  end

  def create_self_contact
    self.default_contact_id = Contact.create(name: self.name.titleize, email: self.email, user_id: self.id, self_created: true).try(:id)
    self.save
  end
  
  def self_contact?
    Contact.find_all_by_user_id(self.id).map(&:self_created).try(:any?) || false
  end

  def default_location? account_location_id
    !self.default_account_location_id.nil? and self.default_account_location_id == account_location_id 
  end

  def default_location account_location_id
    self.default_account_location_id = account_location_id
    self.save
  end

  def is_admin? account_id=nil
    if account_id.nil?
      self.account_roles.map(&:role).include? "administrator"
    else
      account_role = AccountRole.find_record(account_id, id)
      account_role ? account_role.is_admin? : false
    end
  end
  
  def self.send_reset_password_instructions(attributes={})
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    recoverable.send_reset_password_instructions(attributes[:catering]) if recoverable.persisted?
    recoverable
  end
  
  def send_reset_password_instructions(catering)
    generate_reset_password_token! if should_generate_reset_token?
    opts = {}
    opts.merge!(catering: catering) unless catering.blank?
    send_devise_notification(:reset_password_instructions, opts)
  end
  
  def validate_user
    validation_errors = {}
    if self.disable
      validation_error = "User Account has been disabled."
      validation_errors[Digest::MD5.hexdigest(validation_error)] = validation_error        
    end
    validation_errors
  end
  
  def favorite(entity)
    return [] unless self.id
    cid = 'User_' + self.id.to_s + '_Favorite_' + entity.name
    if (user_favorites = Rails.cache.read(cid)).nil?
      user_favorites = entity.evaluated_by(:favorite, self)
      Rails.cache.write(cid, user_favorites, expires_in: 1.week)
      unless Rails.cache.exist?(cid + '_cc')
        Rails.cache.write(cid + '_cc', 0, expires_in: 1.week)
      end
    end
    user_favorites
  end

  def clear_sessions
    ss = Rails.configuration.session_store
    ss::Session.select{|session| session.destroy if session.data["warden.user.user.key"].present? and session.data["warden.user.user.key"][1][0] == self.id}
  end

end
