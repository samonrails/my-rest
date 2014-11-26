class TransactionsController < ApplicationController
  
  def new
    appropriate_transaction_partial, locals = get_appropriate_transaction_modal
    render partial: appropriate_transaction_partial, locals: locals
  end

  def create
    @event = Event.find(params[:event_id])
    settle = params[:settle] ? true : false
    payment_history = PaymentHistory.create_dummy_history params[:event_id], params[:user_id], params[:card], params[:amount]
    Sidekiq::Client.enqueue(BraintreeTransactionNew, @event.id, params[:card], params[:amount], settle, current_user.id, payment_history.id)
    flash[:notice] = "Transaction Submitted for Processing"
    redirect_to event_path(@event, selected: 'payment', anchor: "payment")
  end

  def settle
    @event = Event.find(params[:event_id])
    Sidekiq::Client.enqueue(BraintreeTransactionSettle, @event.id, params[:trans_id], params[:amount], current_user.id)
    flash[:notice] = "Transaction Submitted for Processing"
    redirect_to event_path(@event, selected: 'payment', anchor: "payment")
  end

  def void
    @event = Event.find(params[:event_id])
    Sidekiq::Client.enqueue(BraintreeTransactionVoid, @event.id, params[:trans_id], current_user.id)
    flash[:notice] = "Transaction Submitted for Processing"
    redirect_to event_path(@event, selected: 'payment', anchor: "payment")
  end

  def refund
    @event = Event.find(params[:event_id])
    Sidekiq::Client.enqueue(BraintreeTransactionRefund, @event.id, params[:trans_id], params[:amount], current_user.id)
    flash[:notice] = "Transaction Submitted for Processing"
    redirect_to event_path(@event, selected: 'payment', anchor: "payment")
  end

  private

  def get_appropriate_transaction_modal
    #this will throw an error if the specified event doesn't exist
    @event = Event.find params[:event_id]

    @transaction_modal_partial = "events/partials_payment/transactions/event_transaction_misconfigured"
    @locals = {}

    if @event.event_transaction_method.transaction_card_token.nil? == false
      @transaction_modal_partial = "events/partials_payment/transactions/new"
      card = Braintree::CreditCard.find @event.event_transaction_method.transaction_card_token
      @locals = { card: card}
    end

    return @transaction_modal_partial, @locals
  end
end 
