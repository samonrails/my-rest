require 'net/http'
require 'net/https'
require 'uri'

module MaxEmail 

  def self.email_address fax_number
    raise "Incorrect 11 digit fax number: #{fax_number}" unless fax_number.match(/\d{11}/)
    "#{fax_number}@maxemailsend.com"
  end

  def self.s3_attachment key
    uri = URI.parse AWS.private_document_url(key)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.request(Net::HTTP::Get.new(uri.request_uri)).body
  end
end