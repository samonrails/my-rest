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

require 'spec_helper'

describe SelectEventSchedule do
  pending "add some examples to (or delete) #{__FILE__}"
end
