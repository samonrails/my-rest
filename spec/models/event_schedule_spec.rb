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

require 'spec_helper'

describe EventSchedule do

  let(:vendor) { create(:vendor) }
  let(:account) { create(:account) }
  let(:contact) { create(:contact) }
  let(:location) { create(:location) }
  let(:user) { create(:user, :confirmed) }

  let (:event_schedule) do
    schedule = EventSchedule.create!(
      :product => 'catering',
      :location => location,
      :account => account,
      :contact => contact,
      :schedule_start_date => Date.new(2013,6,30),
      :event_start_time => DateTime.parse("Thu, 11 Jul 2013 11:30"),
      :event_end_time => DateTime.parse("Thu, 11 Jul 2013 13:30"),
      :setup_start_time => DateTime.parse("Thu, 11 Jul 2013 10:30"),
      :setup_end_time => DateTime.parse("Thu, 11 Jul 2013 11:29"),
      :meal_period => 'Lunch',
      :created_by => user,
      :created_at =>  Date.new(2013,6,30),
      :days_to_schedule => 7,
      :schedule => '{"interval":1,"until":null,"count":null,"validations":null,"rule_type":"IceCube::DailyRule"}')

    schedule
  end

  let (:mw_schedule) do
    '{"validations":{"day":[1,3]},"rule_type":"IceCube::WeeklyRule","interval":1,"week_start":0}'
  end

  let (:mwf_schedule) do
    '{"validations":{"day":[1,3,5]},"rule_type":"IceCube::WeeklyRule","interval":1,"week_start":0}'
  end

  let (:mwtf_schedule) do
    '{"validations":{"day":[1,3,4,5]},"rule_type":"IceCube::WeeklyRule","interval":1,"week_start":0}'
  end

  let (:sunday) do
    Date.new(2013,6,30)
  end

  it 'should be valid' do
    event_schedule.should be_valid
  end

  it 'should not have any events associated to it before it has been run' do
    event_schedule.save
    Event.where(:event_schedule_id => event_schedule.id).count.should == 0
  end

  it 'should have processed date set to 7 days from now after processing a 7 day job ' do
    event_schedule.process
    event_schedule.processed_until.to_date.should == (Time.now.utc + 7.days).to_date
  end

  it 'should create seven events given a daily schedule and 7 days to schedule' do
    event_schedule.process
    Event.where(:event_schedule_id => event_schedule.id).count.should == 7

    count = 1
    Event.where(:event_schedule_id => event_schedule.id).sort_by{|e| e.event_start_time}.each do |e|
      e.location_id.should == event_schedule.location.id
      e.contact_id.should == event_schedule.contact.id
      e.product.should == event_schedule.product
      e.meal_period.should == event_schedule.meal_period

      date = Date.today + count.days
      e.event_start_time.should == event_schedule.event_start_time.change(:year => date.year).change(:month => date.month).change(:day => date.day)
      e.event_end_time.should == event_schedule.event_end_time.change(:year => date.year).change(:month => date.month).change(:day => date.day)
      e.setup_start_time.should == event_schedule.setup_start_time.change(:year => date.year).change(:month => date.month).change(:day => date.day)
      e.setup_end_time.should == event_schedule.setup_end_time.change(:year => date.year).change(:month => date.month).change(:day => date.day)
      count = count + 1
    end
  end

  it 'should create seven events given a daily schedule and 7 days to schedule, and then run the next day with different event-related times' do
    event_schedule.process

    Event.where(:event_schedule_id => event_schedule.id).count.should == 7

    Delorean.time_travel_to "1 days from now" do
      event_schedule.event_start_time = event_schedule.event_start_time + 1.hours
      event_schedule.event_end_time = event_schedule.event_end_time + 2.hours
      event_schedule.setup_start_time = event_schedule.setup_start_time + 3.hours
      event_schedule.setup_end_time = event_schedule.setup_end_time + 4.hours
      event_schedule.save

      event_schedule.process
      Event.where(:event_schedule_id => event_schedule.id).count.should == 8

      count = 0
      Event.where(:event_schedule_id => event_schedule.id).sort_by{|e| e.event_start_time}.each do |e|
        e.location_id.should == event_schedule.location.id
        e.contact_id.should == event_schedule.contact.id
        e.product.should == event_schedule.product
        e.meal_period.should == event_schedule.meal_period

        date = Date.today + count.days
        if (count == 0)
          e.event_start_time.should == event_schedule.event_start_time.change(:year => date.year).change(:month => date.month).change(:day => date.day) - 1.hours
          e.event_end_time.should == event_schedule.event_end_time.change(:year => date.year).change(:month => date.month).change(:day => date.day) - 2.hours
          e.setup_start_time.should == event_schedule.setup_start_time.change(:year => date.year).change(:month => date.month).change(:day => date.day) - 3.hours
          e.setup_end_time.should == event_schedule.setup_end_time.change(:year => date.year).change(:month => date.month).change(:day => date.day) - 4.hours
        else
          e.event_start_time.should == event_schedule.event_start_time.change(:year => date.year).change(:month => date.month).change(:day => date.day)
          e.event_end_time.should == event_schedule.event_end_time.change(:year => date.year).change(:month => date.month).change(:day => date.day)
          e.setup_start_time.should == event_schedule.setup_start_time.change(:year => date.year).change(:month => date.month).change(:day => date.day)
          e.setup_end_time.should == event_schedule.setup_end_time.change(:year => date.year).change(:month => date.month).change(:day => date.day)
        end
        count = count + 1
      end
    end
  end

  it 'should create seven events given a daily schedule and 7 days to schedule, and then run the next day with different event-related times, but not change one event due to it being set to active' do
    event_schedule.process

    Event.where(:event_schedule_id => event_schedule.id).count.should == 7

    Delorean.time_travel_to "1 days from now" do
      event_schedule.event_start_time = event_schedule.event_start_time + 1.hours
      event_schedule.event_end_time = event_schedule.event_end_time + 2.hours
      event_schedule.setup_start_time = event_schedule.setup_start_time + 3.hours
      event_schedule.setup_end_time = event_schedule.setup_end_time + 4.hours
      event_schedule.save

      [Event.where(:event_schedule_id => event_schedule.id).sort_by{|e| e.event_start_time}[2]].map{|e| e.status = Status::Event.active; e.save}

      event_schedule.process
      Event.where(:event_schedule_id => event_schedule.id).count.should == 8

      count = 0
      Event.where(:event_schedule_id => event_schedule.id).sort_by{|e| e.event_start_time}.each do |e|
        e.location_id.should == event_schedule.location.id
        e.contact_id.should == event_schedule.contact.id
        e.product.should == event_schedule.product
        e.meal_period.should == event_schedule.meal_period

        date = Date.today + count.days
        if (count == 0 || count == 2)
          e.event_start_time.should == event_schedule.event_start_time.change(:year => date.year).change(:month => date.month).change(:day => date.day) - 1.hours
          e.event_end_time.should == event_schedule.event_end_time.change(:year => date.year).change(:month => date.month).change(:day => date.day) - 2.hours
          e.setup_start_time.should == event_schedule.setup_start_time.change(:year => date.year).change(:month => date.month).change(:day => date.day) - 3.hours
          e.setup_end_time.should == event_schedule.setup_end_time.change(:year => date.year).change(:month => date.month).change(:day => date.day) - 4.hours
        else
          e.event_start_time.should == event_schedule.event_start_time.change(:year => date.year).change(:month => date.month).change(:day => date.day)
          e.event_end_time.should == event_schedule.event_end_time.change(:year => date.year).change(:month => date.month).change(:day => date.day)
          e.setup_start_time.should == event_schedule.setup_start_time.change(:year => date.year).change(:month => date.month).change(:day => date.day)
          e.setup_end_time.should == event_schedule.setup_end_time.change(:year => date.year).change(:month => date.month).change(:day => date.day)
        end
        count = count + 1
      end
    end
  end

  it 'should create eight events given a daily schedule and 7 days to schedule, run on consecutive days' do
    event_schedule.process
    Delorean.time_travel_to "1 days from now" do
      event_schedule.process
      Event.where(:event_schedule_id => event_schedule.id).count.should == 8
    end
  end

  it 'should create five events given a daily schedule and the schedule ending in 4 days' do
    event_schedule.schedule_end_date = Date.today + 5.days
    event_schedule.process
    Event.where(:event_schedule_id => event_schedule.id).count.should == 5
  end

  it 'should create four events given a daily schedule and 7 days to schedule and a pause for 2 days' do
    event_schedule.pause_start_date = Date.today + 2.days
    event_schedule.pause_end_date = Date.today + 4.days
    event_schedule.process
    Event.where(:event_schedule_id => event_schedule.id).count.should == 5
  end

  it 'should create five events given a daily schedule and 7 days to schedule and a pause for 2 days, run on consecutive days' do
    event_schedule.pause_start_date = Date.today + 2.days
    event_schedule.pause_end_date = Date.today + 4.days
    event_schedule.process
    Delorean.time_travel_to "1 days from now" do
      event_schedule.process
      Event.where(:event_schedule_id => event_schedule.id).count.should == 6
    end
  end

  it 'should not create additional events if scheduler has already been ran' do
    event_schedule.process
    Event.where(:event_schedule_id => event_schedule.id).count.should == 7
    total_number_of_events = Event.all.count
    event_schedule.process

    Event.all.count.should == total_number_of_events
  end

  it 'should create two additional events two days from now' do
    event_schedule.process
    Event.where(:event_schedule_id => event_schedule.id).count.should == 7
    Delorean.time_travel_to "2 days from now" do
      event_schedule.process
      Event.where(:event_schedule_id => event_schedule.id).count.should == 9
    end
  end

  it 'should create 3 events, monday, wednesday, friday given a 7 days out and a MWF schedule' do
    event_schedule.schedule = mwf_schedule
    event_schedule.process
    Event.where(:event_schedule_id => event_schedule.id).count.should == 3
  end

  it 'should create 2 events, today is sunday, event scheduler starts tuesday and we are scheduling 7 days out with mwf schedule' do
    event_schedule.schedule = mwf_schedule
    Delorean.time_travel_to sunday do
      event_schedule.schedule_start_date = sunday + 2.days
      event_schedule.process
    end
    Event.where(:event_schedule_id => event_schedule.id).count.should == 2
  end

  it 'should create 3 events for an mwf schedule on Saturday, then create an additional event for thursday after switching to a mwtf schedule' do
    event_schedule.schedule = mwf_schedule

    Delorean.time_travel_to "next week saturday" do
      event_schedule.process
      Event.where(:event_schedule_id => event_schedule.id).count.should == 3

      Delorean.time_travel_to "tomorrow" do
        event_schedule.schedule = mwtf_schedule
        event_schedule.process
        Event.where(:event_schedule_id => event_schedule.id).count.should == 4
      end
    end
  end

  it 'should create 4 events for an mwtf schedule on Saturday, then cancel an event for thursday after switching to a mwf schedule' do
    event_schedule.schedule = mwtf_schedule

    Delorean.time_travel_to "next week saturday" do
      event_schedule.process
      Event.where(:event_schedule_id => event_schedule.id).count.should == 4

      Delorean.time_travel_to "tomorrow" do
        event_schedule.schedule = mwf_schedule
        event_schedule.process
        Event.where(:event_schedule_id => event_schedule.id).count.should == 4
        Event.select{|e| e.event_schedule_id == event_schedule.id && e.status != Status::Event.canceled}.count.should == 3
        Event.select{|e| e.event_schedule_id == event_schedule.id && e.status == Status::Event.canceled}.count.should == 1
      end
    end
  end

  it 'should create 4 events for an mwtf schedule on Saturday, then not cancel an event for thursday after switching to a mwf schedule because it is active' do
    event_schedule.schedule = mwtf_schedule

    Delorean.time_travel_to "next week saturday" do
      event_schedule.process
      Event.where(:event_schedule_id => event_schedule.id).count.should == 4

      [Event.where(:event_schedule_id => event_schedule.id).sort_by{|e| e.event_start_time}[2]].map{|e| e.status = Status::Event.active; e.save}

      Delorean.time_travel_to "tomorrow" do
        event_schedule.schedule = mwf_schedule
        event_schedule.process
        Event.where(:event_schedule_id => event_schedule.id).count.should == 4
        Event.select{|e| e.event_schedule_id == event_schedule.id && e.status != Status::Event.canceled}.count.should == 4
        Event.select{|e| e.event_schedule_id == event_schedule.id && e.status == Status::Event.canceled}.count.should == 0
      end
    end
  end

  it 'should create 3 events, wednesday, friday, monday, today is monday and we are scheduling 7 days out with mwf schedule' do
    event_schedule.schedule = mwf_schedule
    Delorean.time_travel_to sunday + 1.days do
      event_schedule.process
    end
    Event.where(:event_schedule_id => event_schedule.id).count.should == 3
    Event.where(:event_schedule_id => event_schedule.id).last.event_start_time.to_date == sunday + 8.days
  end

  it 'should create 4 events for an mwtf schedule on Saturday, then cancel an event for thursday after switching to a mwf schedule, then replace that event after switching back to a mwtf schedule' do
    event_schedule.schedule = mwtf_schedule

    Delorean.time_travel_to "next week saturday" do
      event_schedule.process
      Event.where(:event_schedule_id => event_schedule.id).count.should == 4

      Delorean.time_travel_to "tomorrow" do
        event_schedule.schedule = mwf_schedule
        event_schedule.process
        Event.where(:event_schedule_id => event_schedule.id).count.should == 4
        Event.select{|e| e.event_schedule_id == event_schedule.id && e.status != Status::Event.canceled}.count.should == 3
        Event.select{|e| e.event_schedule_id == event_schedule.id && e.status == Status::Event.canceled}.count.should == 1

        event_schedule.schedule = mwtf_schedule
        event_schedule.process
        Event.where(:event_schedule_id => event_schedule.id).count.should == 5
        Event.select{|e| e.event_schedule_id == event_schedule.id && e.status != Status::Event.canceled}.count.should == 4
        Event.select{|e| e.event_schedule_id == event_schedule.id && e.status == Status::Event.canceled}.count.should == 1
      end
    end
  end

  it 'should create 4 events for an mwtf schedule on Saturday, then cancel an event for thursday after switching to a mwf schedule, then NOT replace that event after switching back to a mwtf schedule because the canceled reason is not "change_to_recurring_schedule"' do
    event_schedule.schedule = mwtf_schedule

    Delorean.time_travel_to "next week saturday" do
      event_schedule.process
      Event.where(:event_schedule_id => event_schedule.id).count.should == 4

      Delorean.time_travel_to "tomorrow" do
        event_schedule.schedule = mwf_schedule
        event_schedule.process
        Event.where(:event_schedule_id => event_schedule.id).count.should == 4
        Event.select{|e| e.event_schedule_id == event_schedule.id && e.status != Status::Event.canceled}.count.should == 3
        Event.select{|e| e.event_schedule_id == event_schedule.id && e.status == Status::Event.canceled}.count.should == 1

        Event.select{|e| e.event_schedule_id == event_schedule.id && e.status == Status::Event.canceled}.map{|e| e.cancellation_reason = CancellationReason.misread_schedule; e.save;}

        event_schedule.schedule = mwtf_schedule
        event_schedule.process
        Event.where(:event_schedule_id => event_schedule.id).count.should == 4
        Event.select{|e| e.event_schedule_id == event_schedule.id && e.status != Status::Event.canceled}.count.should == 3
        Event.select{|e| e.event_schedule_id == event_schedule.id && e.status == Status::Event.canceled}.count.should == 1
      end
    end
  end

end
