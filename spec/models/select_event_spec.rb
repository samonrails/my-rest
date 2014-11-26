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

require 'spec_helper'

describe SelectEvent do
  pending "add some examples to (or delete) #{__FILE__}"
end
