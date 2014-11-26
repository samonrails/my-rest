# == Schema Information
#
# Table name: event_schedules
#
#  id                      :integer          not null, primary key
#  schedule                :string(255)
#  product                 :string(255)
#  meal_period             :string(255)
#  location_id             :integer
#  days_to_schedule        :integer
#  contact_id              :integer
#  vendor_id               :integer
#  account_id              :integer
#  event_start_time        :datetime
#  event_end_time          :datetime
#  setup_start_time        :datetime
#  setup_end_time          :datetime
#  schedule_start_date     :datetime
#  schedule_end_date       :datetime
#  pause_start_date        :datetime
#  pause_end_date          :datetime
#  processed_until         :datetime
#  created_by_id           :integer
#  menu_template_id        :integer
#  quantity                :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  event_schedule_owner_id :integer
#

class EventSchedule < ApplicationModel
  include IceCube
  include RecurringSelect
  belongs_to :location
  belongs_to :contact
  belongs_to :vendor
  belongs_to :menu_template
  belongs_to :account
  belongs_to :created_by, :class_name => "User"
  belongs_to :event_schedule_owner, :class_name => "User"

  has_many :events, :dependent => :restrict

  validates :account, presence: true
  validates :schedule_start_date, presence: true
  validates :days_to_schedule, presence: true
  validates :event_start_time, presence: true
  validates :location, presence: true, :if => :non_financial_product?
  validates :schedule, exclusion: { in: %w(null), message: " can't be blank"}
  validates :menu_template, presence: {if: :vendor_selected}
  validates :quantity, presence: {if: :vendor_selected}

  # UI display helper methods
  # ---------------------------------------------------------------------------
  def pretty_id
    "#{self.id.to_s.rjust(7, "0")}"
  end

  def event_time
    return_val = event_start_time.strftime("%l:%M %p")
    return_val = return_val + " -" + event_end_time.strftime("%l:%M %p") unless event_end_time.nil?
    return_val
  end

  def vendor_selected
    self.vendor != nil
  end

  def setup_time
    return_val = ""
    if(setup_start_time)
      return_val = setup_start_time.strftime("%l:%M %p")
      return_val = return_val + "-" + setup_end_time.strftime("%l:%M %p") unless setup_end_time.nil?
    end
    return_val
  end

  def schedule_friendly_string
    if self.schedule
      s = RecurringSelect.dirty_hash_to_rule(self.schedule)
      s.to_s
    end
  end

  def active_friendly_string
    date = Date.today
    if self.pause_start_date && self.pause_end_date && (self.pause_start_date.to_date <= date && date < self.pause_end_date.to_date)
      "Paused until " + self.pause_end_date.strftime("%d %B %Y")
    elsif self.schedule_end_date && date > self.schedule_end_date.to_date
      "Expired"
    elsif date < self.schedule_start_date.to_date
      "Not starting until " + self.schedule_start_date.strftime("%d %B %Y")
    else
      "Active"
    end
  end

  # ---------------------------------------------------------------------------
  # END UI display helper methods

  def non_financial_product?
    Product.non_financial_values.include?(self.product)
  end
  
  def process

    Rails.logger.warn "Starting event schedule processing for event schedule #{self.id}"
    rule = RecurringSelect.dirty_hash_to_rule(self.schedule)
    Rails.logger.warn  'Fetched rule: ' + rule.to_s + " for account: " + self.account.name

    # Determine the date to start processing.  This date actually holds a time,
    # but we'll be chopping the time component off
    date_to_start_processing = get_date_to_start_processing_at
    Rails.logger.warn  'Processing from: ' + date_to_start_processing.to_s

    # If there is a pause, then display it
    Rails.logger.warn  'With a pause from: ' + self.pause_start_date.to_s + ' until ' + self.pause_end_date.to_s if (self.pause_start_date && self.pause_end_date)

    # Create the schedule.  The schedule only has date-based rules right now,
    # so the time componets are apparently ignored.
    schedule = Schedule.new(date_to_start_processing) do |s|
      s.add_recurrence_rule(rule)
    end

    # Determine the date to stop
    date_to_stop = Time.now + self.days_to_schedule.days
    Rails.logger.warn  'Processing to: ' + date_to_stop.to_s

    Rails.logger.warn  'Schedule start date: ' + self.schedule_start_date.to_s unless self.schedule_start_date.nil?
    Rails.logger.warn  'Schedule final date: ' + self.schedule_end_date.to_s unless self.schedule_end_date.nil?

    # Determine the number of events to be created
    occurrences = schedule.occurrences(date_to_stop)
    Rails.logger.warn  'Events to be created: ' + occurrences.count.to_s
    
    cancel_dates = []
    (date_to_start_processing.to_date..date_to_stop.to_date).each { |date| cancel_dates.push(date)}

    # Loop the occurrences, and create/modify/cancel the events.
    occurrences.each { |day_to_schedule|

      cancel_dates -= [day_to_schedule.to_date]

      event_on_this_date = event_on_date(day_to_schedule.to_date)

      if is_schedule_active_on_date(day_to_schedule.to_date)
        if !event_on_this_date || (event_on_this_date.status == Status::Event.canceled && event_on_this_date.cancellation_reason == CancellationReason.change_to_recurring_schedule)
          # There is no event on this day, so create it
          Rails.logger.warn   'Creating event for : ' + day_to_schedule.to_s
          create_event day_to_schedule
        elsif [Status::Event.auto_generated].include?(event_on_this_date.status)
          # There is an event on this day, so modify if necessary
          Rails.logger.warn   'Modifying event for : ' + day_to_schedule.to_s
          modify_event event_on_this_date
        end
      else
        Rails.logger.warn   'Skipping: ' + day_to_schedule.to_s + ' schedule inactive (paused/stopped)'
      end
    }

    cancel_dates.each { |cancel_date|

      event_on_this_date = event_on_date(cancel_date)

      if event_on_this_date && [Status::Event.auto_generated].include?(event_on_this_date.status)
        # No event should be on this day, so cancel it
        Rails.logger.warn   'Canceling event for : ' + cancel_date.to_s
        cancel_event event_on_this_date
      end
    }

    self.processed_until = date_to_stop
    self.save
  end

  def is_schedule_active_on_date(date)
    schedule_active = true
    schedule_active &&= (self.pause_start_date.to_date > date || date >= self.pause_end_date.to_date) if (self.pause_start_date && self.pause_end_date)
    schedule_active &&= (date <= self.schedule_end_date.to_date) if (self.schedule_end_date)
    schedule_active
  end

  def event_on_date(date)
    e = Event.select{|e| e.event_schedule_id == self.id && e.event_start_time.year == date.year && e.event_start_time.month == date.month && e.event_start_time.day == date.day }
    e.count > 0 ? e.first : nil
  end

  def get_date_to_start_processing_at
    date_to_start_processing = Time.now + 1.days
    date_to_start_processing = self.schedule_start_date if date_to_start_processing < self.schedule_start_date
    date_to_start_processing
  end

  def create_event(day_to_schedule)
    system_user = User.where(utility_account: true).first
    @event = Event.new(
      :name => "Recurring Event",
      :account_id => self.account_id,
      :product => self.product,
      :status => Status::Event.auto_generated,
      :contact_id => self.contact_id,
      :meal_period => self.meal_period,
      :location_id => self.location_id,
      :event_start_time => change_date_on_date_time_object(self.event_start_time, day_to_schedule),
      :event_end_time => change_date_on_date_time_object(self.event_end_time, day_to_schedule),
      :setup_start_time => change_date_on_date_time_object(self.setup_start_time, day_to_schedule),
      :setup_end_time => change_date_on_date_time_object(self.setup_end_time, day_to_schedule),
      :created_by => system_user,
      :quantity => self.quantity,
      :event_schedule_id => self.id,
      :event_owner_id => self.event_schedule_owner_id
    )
    
    Event.transaction do
      @event.save
      @event.update_transaction_method
      if(self.menu_template)
        @event.add_replace_menu_template self.menu_template.id, self.quantity
      end
    end
    
    self.processed_until = day_to_schedule
    self.save

    Rails.logger.warn 'Created event with event_start_time: ' + @event.event_start_time.to_s
  end

  def modify_event event
    event.update_attributes!(
      :account_id => self.account_id,
      :product => self.product,
      :status => Status::Event.auto_generated,
      :contact_id => self.contact_id,
      :meal_period => self.meal_period,
      :location_id => self.location_id,
      :event_start_time => event.event_start_time.nil? ? nil : change_date_on_date_time_object(self.event_start_time, event.event_start_time),
      :event_end_time => event.event_end_time.nil? ? nil : change_date_on_date_time_object(self.event_end_time, event.event_end_time),
      :setup_start_time => event.setup_start_time.nil? ? nil : change_date_on_date_time_object(self.setup_start_time, event.setup_start_time),
      :setup_end_time => event.setup_end_time.nil? ? nil : change_date_on_date_time_object(self.setup_end_time, event.setup_end_time),
      :quantity => self.quantity
    )
    
    if self.menu_template
      if event.event_vendors && event.event_vendors.count > 0
        if (event.event_vendors.count == 1) && (event.event_vendors.first.vendor_id == self.menu_template.vendor_id) && (event.event_vendors.first.menu_template_id != self.menu_template.id)
          # One vendor configured, same vendor, different menu template
          event.add_replace_menu_template(self.menu_template.id, self.quantity)
        elsif (event.event_vendors.count == 1) && (event.event_vendors.first.vendor_id != self.menu_template.vendor_id)
          # One vendor configured, different vendor
          event.remove_info_for_vendor(event.event_vendors.first.vendor_id)
          event.add_replace_menu_template(self.menu_template.id, self.quantity)
        elsif (event.event_vendors.count > 1)
          # Multiple vendors.  Clear them all out, and add the new menu template.
          vendor_ids = event.event_vendors.map{|ev| ev.vendor_id}
          vendor_ids.each {|id| event.remove_info_for_vendor(id)}
          event.add_replace_menu_template(self.menu_template.id, self.quantity)
        end
      else
        # No event vendors, so add one
        event.add_replace_menu_template(self.menu_template.id, self.quantity)
      end
    else
      # No menu template configured.  Clear out all the existing vendors.
      if event.event_vendors
        vendor_ids = event.event_vendors.map{|ev| ev.vendor_id}
        vendor_ids.each {|id| event.remove_info_for_vendor(id)}
      end
    end

    Rails.logger.warn 'Modified event with event_start_time: ' + event.event_start_time.to_s
  end

  def cancel_event(event)
    event.status = Status::Event.canceled
    event.cancellation_reason = CancellationReason.change_to_recurring_schedule
    event.save
    Rails.logger.warn 'Cancelled event with event_start_time: ' + event.event_start_time.to_s
  end

  def change_date_on_date_time_object(date_from, date_to)
    if date_from
      date_from = date_from.change(day: date_to.day)
      date_from = date_from.change(month: date_to.month)
      date_from = date_from.change(year: date_to.year)
    end
    date_from
  end

end

