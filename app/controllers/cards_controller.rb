class CardsController < ApplicationController
  authorize_resource

  def index
    @event = Event.find(params[:event_id])
    user = User.find(params[:user_id])
    show_new_card = params[:user_id] == @event.event_transaction_method.user_id.to_s
    render partial: "events/partials_payment/cards/index", locals: { user: user.id == 0 ? nil : user, show_new_card: show_new_card}
  end

  def show
    @event = Event.find(params[:event_id])
    card = Braintree::CreditCard.find params[:id]
    render partial: "events/partials_payment/cards/show", locals: {card: card}
  end

  def create
    result = Braintree.create_verified(params[:user_id], params[:card], params.slice(:nickname, :account_id))
    if result.success?
      flash[:notice] = "Card Added Successfully" 
    else
      flash[:error] = "Error adding card - #{result.message}"
    end
    redirect_to :back
  end

  def update
    #pull event_transaction_method#update_card to here -djb
  end
end