class CateringSubdomain
  def self.matches? request
    domains = %w(catering catering-staging catering-experimental catering-demo catering-qa catering-experimental-alpha catering-experimental-bravo catering-experimental-charlie catering-experimental-delta catering-experimental-echo catering-experimental-foxtrot catering-experimental-golf catering-experimental-india catering-experimental-hotel)
    domains.map{|v| [v,"www.#{v}"]}.flatten.include? request.subdomain 
  end
end
