# Preview of tomorrow's catering schedule

class MaxEmailJob
  include Sidekiq::Worker

  def perform(fax_number, s3_file_name)
    MaxEmailMailer.send_fax(fax_number.to_s, s3_file_name).deliver
    Rails.logger.info "Sent file: #{s3_file_name} as a fax to: #{fax_number}" 
  end
end
