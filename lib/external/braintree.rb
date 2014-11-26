module Braintree

  def self.create_verified user_id, card, options={}
    user = User.find(user_id)
    card[:options] ||= {}
    card.merge!(customer_id: user.braintree_identity)[:options].merge!(verify_card: true)
    result = Braintree::CreditCard.create(card)
    update_card_meta result.credit_card.token, user, card, options
    result
  end

  protected
    def self.update_card_meta token, user, card_params, options={}
      card = Card.find_or_create_by_token_and_user_id(token, user.id)
      options[:account_id] = nil unless user.is_admin?(options[:account_id])
      card.update_attributes(nickname: options[:nickname], account_id: options[:account_id])
      if (card_params[:options] and card_params[:options]["make_default"] == "true") or user.default_billing_id.nil?
        user.update_attributes(default_billing_id: card.id, default_account_id: nil, payment_method: 'credit_card')
      end
    end
end