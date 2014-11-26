module LocationPrivacy
  def self.available_values 
    %w{public private invite_only} 
  end

  def self.public
    "public"
  end

  def self.private
    "private"
  end
    
  def self.invite_only
    "invite_only"
  end
end