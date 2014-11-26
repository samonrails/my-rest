# == Schema Information
#
# Table name: emails
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  email_list :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Email < ApplicationModel
  validates :email, :email_list, presence: true

  public 

    def self.end_of_day_sales_report
      Email.where :email_list => "new_catering_sales"
    end

    def self.catering_schedule_preview
      Email.where :email_list => "catering_schedule_preview"
    end

    def self.vendor_billing_summaries
      Email.where :email_list => "vendor_billing_summaries"
    end

    def self.insurance_expiration_report
      Email.where :email_list => "insurance_expiration_report"
    end

end