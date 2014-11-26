# == Schema Information
#
# Table name: select_events
#
#  id                                        :integer          not null, primary key
#  ready_and_bagged                          :integer          not null
#  delivery_time                             :datetime
#  delivery_time_utc                         :datetime
#  ordering_window_start_time                :datetime
#  ordering_window_end_time                  :datetime
#  ordering_window_start_time_utc            :datetime
#  ordering_window_end_time_utc              :datetime
#  created_by_id                             :integer
#  deleted_by_id                             :integer
#  created_at                                :datetime         not null
#  updated_at                                :datetime         not null
#  deleted_at                                :datetime
#  gratuity_payer                            :string(255)      default("user")
#  default_gratuity                          :decimal(, )      default(10.0)
#  delivery_fee_payer                        :string(255)      default("user")
#  tax_payer                                 :string(255)      default("user")
#  subsidy                                   :string(255)      default("none")
#  is_subsidy_percentage_capped              :boolean          default(FALSE)
#  subsidy_percentage_cap                    :decimal(, )
#  subsidy_percentage_fixed_amount_cap_cents :integer
#  subsidy_fixed_amount_cents                :integer
#  hide_gratuity_from_site                   :boolean          default(FALSE)
#  hide_delivery_fee_from_site               :boolean          default(FALSE)
#  hide_tax_from_site                        :boolean          default(FALSE)
#  account_id                                :integer
#  location_id                               :integer
#  contact_id                                :integer
#  meal_period                               :string(255)
#  event_owner_id                            :integer
#  status                                    :string(255)
#  email_list_id                             :string(255)
#  introduction_email_time                   :datetime
#  final_email_time                          :datetime
#  introduction_email_campaign_id            :integer
#  final_email_campaign_id                   :integer
#  user_contribution_required                :boolean          default(FALSE)
#  user_contribution_cents                   :integer
#  introduction_email_time_utc               :datetime
#  final_email_time_utc                      :datetime
#

class SelectEvent < ActiveRecord::Base
  # attr_accessible :title, :body
  include Fooda::Asset
  searchkick
  acts_as_paranoid
  
  belongs_to :created_by, :class_name => "User"
  belongs_to :deleted_by, :class_name => "User"
  belongs_to :event_owner, :class_name => "User"
  
  has_many :issues, as: :subject
  has_many :select_event_billing_references
  has_many :billing_references, :through  => :select_event_billing_references, :dependent => :restrict
  has_many :menu_templates, :through => :select_event_vendors
  
  belongs_to :account
  belongs_to :contact
  belongs_to :location
  belongs_to :select_event_campaign 

  before_save :update_utc_dates
  before_save :subsidy_values
  
  has_many :select_event_vendors, :dependent => :destroy
  has_many :vendors, :through => :select_event_vendors, :dependent => :restrict
  has_many :select_event_campaigns, :dependent => :destroy
  has_many :select_orders, :class_name => "Select::SelectOrder"

  validates_presence_of :account_id
  validates_presence_of :location
  validates_presence_of :ready_and_bagged, :delivery_time, :ordering_window_start_time, :ordering_window_end_time
  
  # Monetary stuff
  validates :subsidy_percentage_fixed_amount_cap_cents, :numericality => true
  validates :subsidy_fixed_amount_cents, :numericality => true
  validates :user_contribution_cents, :numericality => true
  
  monetize :subsidy_percentage_fixed_amount_cap_cents
  monetize :subsidy_fixed_amount_cents
  monetize :user_contribution_cents
  
  DATETIME = "%A, %m/%d/%Y at %I:%M%p"
  TIME = "%I:%M%p"
  
  accepts_nested_attributes_for :select_event_vendors

  after_create :link_billing_references

  after_initialize :initial_values
  
  def update_utc_dates
    self.ordering_window_start_time_utc = local_with_no_timezone_to_utc(ordering_window_start_time) unless ordering_window_start_time.nil?
    self.ordering_window_end_time_utc = local_with_no_timezone_to_utc(ordering_window_end_time) unless ordering_window_end_time.nil?
    self.delivery_time_utc = local_with_no_timezone_to_utc(delivery_time) unless delivery_time.nil?

    self.introduction_email_time_utc = local_with_no_timezone_to_utc(introduction_email_time) unless introduction_email_time.nil?
    self.final_email_time_utc = local_with_no_timezone_to_utc(final_email_time) unless final_email_time.nil?

  end

  def to_s
    "Select Event: " + self.id.to_s
  end

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
  
  def link_billing_references
    self.account.billing_references.each do |billing_reference|
      SelectEventBillingReference.create!(:select_event_id => self.id, :billing_reference_id => billing_reference.id )
    end
  end

  def local_with_no_timezone_to_utc val
    if location and location.building and location.building.timezone
      ActiveSupport::TimeZone[location.building.timezone].parse(val.strftime("%d %B %Y %l:%M %p")).utc
    else
      val
    end
  end

  def create_pending_campaigns created_by_id, params
 
   # Create a pending campaign for each type - must happen immediately now before the sidekiq job

    pending_campaign_properties = { :state => "pending", 
                                    :scheduled_at => params[:select_event][:introduction_email_time], 
                                    :scheduled_at_utc => self.introduction_email_time_utc,
                                    :email_type => "introduction",
                                    :email_list_id => params[:select_event][:email_list_id],
                                    :created_by_id =>  created_by_id,
                                  }

    intro_created_campaign = self.select_event_campaigns.create( pending_campaign_properties )

    # Pending for final email
    pending_campaign_properties[:email_type] = "final"
    pending_campaign_properties[:scheduled_at] = params[:select_event][:final_email_time]
    pending_campaign_properties[:scheduled_at_utc] = self.final_email_time_utc

    final_email_campaign_id = self.select_event_campaigns.create( pending_campaign_properties )

    { :introduction => intro_created_campaign.id, :final => final_email_campaign_id.id }
  end

  def schedule_email_campaigns campaign_options={}

    # Create the new select_event_campaign for both intro and then final
    #options: { :list_id, :subject, :from_email, :from_name, :to_name }}
    options = { :subject => "This is the subject", :from_email => "dave.bremner2@gmail.com",
                :from_name => "Fooda", 
                :to_name => "Foodizans", :list_id => self.email_list_id  }
    
    # Schedule the Introduction Emails
    select_event_properties = { :id => self.id, :type => "introduction", 
                                :campaign_created_by_id => campaign_options[:campaign_created_by_id] || 0,
                                :campaign_time =>  campaign_options[:formatted_introduction_email_time], 
                                :select_event_campaign_id => campaign_options[:campaign_id][:introduction], 
                              }

    Mailchimp.create_plaintext_campaign "Email content here", select_event_properties,  options


    # Schedule the Final Emails
    select_event_properties[:type] = "final"
    select_event_properties[:campaign_time] = campaign_options[:formatted_final_email_time]
    select_event_properties[:select_event_campaign_id] = campaign_options[:campaign_id][:final]
    Mailchimp.create_plaintext_campaign "Final Email content here", select_event_properties,  options

    
  end

  def worker_create_campaign select_event_properties, mailchimp_response
    # Called from Mailchimp::CreateCampaignWorker

    gibbon = Mailchimp.gibbon_api

    # Find the currently scheduled campaigns and unschedule them - make them draft
    self.select_event_campaigns.where(:email_type => select_event_properties['type'], :state => "scheduled").each do |current_campaign|
      gibbon.campaigns.unschedule ({ :cid => current_campaign.campaign_id })
    end


    # Clear all old campaigns for this type in our database
    self.select_event_campaigns.where( "state != ?", "failed")
                               .where( :email_type => select_event_properties['type'])
                              .update_all(:state => "inactive")

    
    # Schedule the job
    mailchimp_schedule_response = gibbon.campaigns.schedule ({ :cid =>  mailchimp_response["id"], 
                                                               :schedule_time => select_event_properties['campaign_time'],
                                                             })

    created_campaign = SelectEventCampaign.find( select_event_properties["select_event_campaign_id"] )

    # Check mailchimp_schedule_response

    if mailchimp_schedule_response["complete"]
      created_campaign.update_attributes( :state => "scheduled", 
                                          :campaign_web_id => mailchimp_response["web_id"], 
                                          :campaign_id => mailchimp_response["id"],
                                        )
      
      if select_event_properties['type'] == 'introduction'
        self.introduction_email_campaign_id = created_campaign[:id]
      elsif select_event_properties['type'] == 'final'
        self.final_email_campaign_id = created_campaign[:id]
      end

    else
      # Email user
      created_campaign.update_attributes( :state => "failed" )
    end

      
    self.save

  end

  def market_tax_rate
    self.try(:location).try(:building).try(:market).try(:default_tax_rate)
  end


  # ---------------------------------------------------------------------------
  # Searching
  # ---------------------------------------------------------------------------
  
  
  def search_data
    {
      id: id,
      account_id: account_id,
      account_names: account.try(:name).try(:downcase),
      meal_period: meal_period.try(:downcase),
      vendor_names: vendors.map{|v| v.name.downcase},
      vendor_id: vendors.map(&:id),
      event_start_time: delivery_time,
      delivery_time: delivery_time,
      status: status.downcase,
      product: ProductType.select.downcase,
      markets: try(:location).try(:building).try(:market).try(:name).try(:downcase),
      account_executive: created_by.try(:email).try(:downcase),
      created_at: created_at
    }
  end


  private
    def initial_values
      self.status ||= Status::Event.proposed
      self.subsidy_percentage_fixed_amount_cap_cents  ||= 0
      self.subsidy_fixed_amount_cents  ||= 0
      self.ready_and_bagged ||= 40
      self.user_contribution_cents ||= 0
    end
  
end
