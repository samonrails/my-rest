require 'rubygems'
require 'oauth' 

class Yelp
  
  def self.find(vendor)
    token = self.initialize_consumer
    path = "/v2/search?term=#{vendor.name.gsub(' ', '+')}&location=#{vendor.address.to_s.gsub(/\s+/, "+")}&category=restaurants&limit=1"
    result = ::JSON.parse(token.get(path).body)
      unless result["error"] || result["businesses"].empty? || !vendor.yelp_id.nil?
        vendor.update_attributes(:yelp_id => result["businesses"][0]["id"])
        self.update(vendor)
      end
  end
  
  def self.update(vendor)
    token = self.initialize_consumer
    Vendor.skip_callbacks = true
    unless vendor.yelp_id.nil?
      path = "/v2/business/#{vendor.yelp_id}"
      result = ::JSON.parse(token.get(path).body)
      vendor.update_attributes(:rating => result["rating"], :review_count => result["review_count"], :rating_image_url => result["rating_img_url"], :yelp_url => result["mobile_url"])
    end
    Vendor.skip_callbacks = false
  end

  private

  def self.initialize_consumer
    consumer_key = YELP::Consumer_key
    consumer_secret = YELP::Consumer_secret
    token = YELP::Token
    token_secret = YELP::Token_secret
    api_host = 'api.yelp.com'
    consumer = OAuth::Consumer.new(consumer_key, consumer_secret, {:site => "http://#{api_host}"})
    access_token = OAuth::AccessToken.new(consumer, token, token_secret)
  end

end