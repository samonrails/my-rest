class BraintreeTransactionNew
  include Sidekiq::Worker

  def perform(event_id, card, amount, settle, user, custom_transaction_id = nil)
    event = Event.find_by_id event_id
    event.new_transaction(card, amount, settle, user, custom_transaction_id)
  end
end

class BraintreeTransactionSettle
  include Sidekiq::Worker

  def perform(event_id, trans_id, amount, user)
    event = Event.find event_id
    event.settle_transaction(trans_id, amount, user)
  end
end

class BraintreeTransactionVoid
  include Sidekiq::Worker

  def perform(event_id, trans_id, user)
    event = Event.find event_id
    event.void_transaction(trans_id, user)
  end
end

class BraintreeTransactionRefund
  include Sidekiq::Worker

  def perform(event_id, trans, amount, user)
    event = Event.find event_id
    event.refund_transaction(trans, amount, user)
  end
end

class CheckForSettling
  include Sidekiq::Worker
  include Sidetiq::Schedulable
  sidekiq_options :queue => :cron

  recurrence do
    hourly.minute_of_hour(0,30)
  end

  def perform
    EventTransaction.unsettled.each do |et|
      et.check_for_settling
    end
  end
end
