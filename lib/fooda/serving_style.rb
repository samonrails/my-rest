module ServingStyle

  def self.available_values
    %w{serving drop_off staffed}
  end

  def self.serving
    "serving"
  end

  def self.drop_off
    "drop_off"
  end

  def self.staffed
    "staffed"
  end
end
