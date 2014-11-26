class MaxEmailMailer < ActionMailer::Base
  default from: "info@fooda.com"

  def send_fax(fax_number, aws_s3_key)
    email_address = MaxEmail.email_address fax_number
    attachments[aws_s3_key] = MaxEmail.s3_attachment aws_s3_key
    mail(to: email_address, subject: "{NOCOVERPAGE}")
  end
end