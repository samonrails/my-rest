# == Schema Information
#
# Table name: capacities
#
#  id         :integer          not null, primary key
#  day        :integer
#  start_time :time
#  end_time   :time
#  is_closed  :boolean          default(FALSE)
#  vendor_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Capacity < ApplicationModel
  belongs_to :vendor
  validates :start_time, :end_time, presence: true 
  WDAY = {1 => "Mon", 2 => "Tue", 3 => "Wed", 4 => "Thu", 5 => "Fri", 6 => "Sat", 7 => "Sun"}
  
  # Memcache Integration
  after_create  :inc_cache_counter
  after_update  :inc_cache_counter
  after_destroy :inc_cache_counter
end