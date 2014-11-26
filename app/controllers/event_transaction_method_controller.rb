class EventTransactionMethodController < ApplicationController
  authorize_resource
  respond_to :json

  def update    
    card = Braintree::CreditCard.find params[:event_transaction_method][:transaction_card_token] if params[:event_transaction_method][:transaction_card_token]
    params[:event_transaction_method].merge!({ info1: card.try(:cardholder_name), info2: card.try(:last_4)})
    params[:event_transaction_method].merge!({transaction_card_token: nil}) unless params[:event_transaction_method][:transaction_card_token]
    params[:event_transaction_method][:user_id] = nil if params[:event_transaction_method][:user_id] == "0"; #don't save the 0 user, it's the system.
    @event_transaction_method = EventTransactionMethod.find(params[:id])
    @event_transaction_method.update_attributes(permitted_params.event_transaction_method)
    respond_to do |format|
      format.json { render json: {user_name: @event_transaction_method.try(:user).try(:name)} }
    end
  end
end