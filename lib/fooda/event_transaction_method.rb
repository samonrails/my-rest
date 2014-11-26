module EventTransactionMethodType
  def self.available_values
    %w{credit_card on_account}
  end

  def self.credit_card
    "credit_card"
  end

  def self.on_account
    "on_account"
  end
end
