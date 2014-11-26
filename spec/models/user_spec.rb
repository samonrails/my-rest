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

require "spec_helper"

describe User do
  let(:user) { FactoryGirl.create(:user, :confirmed) }

  it "should be valid" do
    user.should be_valid
  end

  it "should have proper associations with issues" do
    user.opened_assigned_issues.class.should be Array
    user.closed_assigned_issues.class.should be Array
    user.opened_reported_issues.class.should be Array
    user.closed_reported_issues.class.should be Array
  end

end
