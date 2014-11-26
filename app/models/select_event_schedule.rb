# == Schema Information
#
# Table name: select_event_schedules
#
#  id                                        :integer          not null, primary key
#  schedule                                  :string(255)
#  ready_and_bagged                          :integer          default(40), not null
#  delivery_time                             :time
#  ordering_window_start_time                :time
#  ordering_window_end_time                  :time
#  created_by_id                             :integer
#  created_at                                :datetime         not null
#  account_id                                :integer
#  location_id                               :integer
#  product                                   :string(255)
#  contact_id                                :integer
#  meal_period                               :string(255)
#  event_schedule_owner_id                   :integer
#  gratuity_payer                            :string(255)      default("user")
#  default_gratuity                          :integer          default(10)
#  delivery_fee_payer                        :string(255)      default("user")
#  tax_payer                                 :string(255)      default("user")
#  string                                    :string(255)      default("user")
#  subsidy                                   :string(255)      default("none")
#  is_subsidy_percentage_capped              :boolean          default(FALSE)
#  subsidy_percentage_cap                    :integer
#  subsidy_percentage_fixed_amount_cap_cents :integer
#  updated_at                                :datetime         not null
#  hide_gratuity_from_site                   :boolean          default(FALSE)
#  hide_delivery_fee_from_site               :boolean          default(FALSE)
#  hide_tax_from_site                        :boolean          default(FALSE)
#  subsidy_fixed_amount_cents                :integer
#  email_list_id                             :string(255)
#  introduction_email_time                   :time
#  final_email_time                          :time
#  user_contribution_required                :boolean          default(FALSE)
#  user_contribution_cents                   :integer
#  schedule_start_date                       :datetime
#  schedule_end_date                         :datetime
#  pause_start_date                          :datetime
#  pause_end_date                            :datetime
#  days_to_schedule                          :integer
#

class SelectEventSchedule < ActiveRecord::Base
  include IceCube
  include RecurringSelect
  # attr_accessible :title, :body
  belongs_to :location
  belongs_to :contact
  belongs_to :account
  belongs_to :vendor
  belongs_to :created_by, :class_name => "User"
  belongs_to :event_schedule_owner, :class_name => "User"
  
  validates :account, presence: true
  validates :schedule_start_date, presence: true
  validates :days_to_schedule, presence: true
  validates :delivery_time, presence: true
  validates :location, presence: true
  validates :schedule, exclusion: { in: %w(null), message: " can't be blank"}

  has_many :vendors, :through => :select_event_schedule_vendors
  has_many :select_event_schedule_vendors, :dependent => :destroy

  has_many :billing_references, :through  => :select_event_schedule_billing_references
  has_many :select_event_schedule_billing_references, :dependent => :destroy
  
  
  # Monetary stuff
  validates :subsidy_percentage_fixed_amount_cap_cents, :numericality => true
  validates :subsidy_fixed_amount_cents, :numericality => true
  validates :user_contribution_cents, :numericality => true
  
  monetize :subsidy_percentage_fixed_amount_cap_cents
  monetize :subsidy_fixed_amount_cents
  monetize :user_contribution_cents
  
  validates_presence_of :account
  validates_presence_of :location
  validates_presence_of :ready_and_bagged, :delivery_time, :ordering_window_start_time, :ordering_window_end_time
  
  
  
  after_create :link_billing_references

  DATETIME = "%A, %m/%d/%Y at %I:%M%p"
  TIME = "%I:%M%p"
  
  after_initialize :initial_values
  
  def subsidy_values
    if subsidy != 'percentage'
      self.is_subsidy_percentage_capped = false
      self.subsidy_percentage_cap = 0
      self.subsidy_percentage_fixed_amount_cap_cents = 0
    elsif subsidy == 'percentage'
      if !is_subsidy_percentage_capped
        self.subsidy_percentage_fixed_amount_cap_cents = 0
      end
    end
    if subsidy != 'fixed_amount'
      self.subsidy_fixed_amount_cents = 0
    end

    if subsidy == 'none'
      self.user_contribution_cents = 0
      self.user_contribution_required = false
    elsif self.user_contribution_cents > 0
      self.user_contribution_required = true
    elsif self.user_contribution_cents <= 0
      self.user_contribution_required = false
    end   
    
    true
  end

  def active_friendly_string
    date = Date.today
    if self.pause_start_date && self.pause_end_date && (self.pause_start_date.to_date <= date && date < self.pause_end_date.to_date)
      "Paused until " + self.pause_end_date.strftime("%d %B %Y")
    elsif self.schedule_end_date && date > self.schedule_end_date.to_date
      "Expired"
    elsif self.schedule_start_date && date < self.schedule_start_date.to_date
      "Not starting until " + self.schedule_start_date.strftime("%d %B %Y")
    else
      "Active"
    end
  end

  def processed_until
    # This has to be filled in when the events are created
    Time.now + self.days_to_schedule.days
  end


  def schedule_friendly_string
    if self.schedule
      s = RecurringSelect.dirty_hash_to_rule(self.schedule)
      s.to_s
    end
  end

  def event_time
    return_val = delivery_time.strftime("%l:%M %p") unless delivery_time.nil?
    return_val
  end

  def link_billing_references
    self.account.billing_references.each do |billing_reference|
      SelectEventScheduleBillingReference.create!(:select_event_schedule_id => self.id, :billing_reference_id => billing_reference.id )
    end
  end
  
  private
    def initial_values
      self.subsidy_percentage_fixed_amount_cap_cents  ||= 0
      self.subsidy_fixed_amount_cents  ||= 0
      self.ready_and_bagged ||= 40
      self.user_contribution_cents ||= 0
      self.product = ProductType.select
    end
  
end
