module DocumentStatus
  def self.available_values
    %w{requested created error}
  end

  def self.requested
    "requested"
  end

  def self.created
    "created"
  end
  def self.error
    "error"
  end
end
