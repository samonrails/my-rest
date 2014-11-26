module LocationType
  def self.available_values
    %w{spot delivery}
  end

  def self.spot
    "spot"
  end

  def self.delivery
    "delivery"
  end
end