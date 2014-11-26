module AccountType
    def self.available_values
    %w{residential corporate office_lobby}
  end

  def self.residential
    "residential"
  end

  def self.corporate
    "corporate"
  end

  def self.office_lobby
    "office_lobby"
  end

end