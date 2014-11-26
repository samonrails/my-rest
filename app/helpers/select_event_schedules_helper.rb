module SelectEventSchedulesHelper

	def select_event_schedule_default_times
		default_times = {}

		default_times[:delivery_time] = (Date.today.beginning_of_day + 12.hours)
		default_times[:ordering_window_start_time] = (Date.today.beginning_of_day + 16.hours)
		default_times[:ordering_window_end_time] = (Date.today.beginning_of_day + 10.hours)

		default_times
	end


end
