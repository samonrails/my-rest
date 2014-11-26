#TODO Not sure I need this -djb

module OrderConfirmationMailWithVoucherJob
  @queue = :order_confirmation_mails
  
  def self.perform(order_id, user_id)
    Catering::Mailer.order_receipt_to_user(order_id, {user_id: user_id}).deliver
    Catering::Mailer.order_receipt_to_user(order_id, {email: "ops@fooda.com"}).deliver
  end
end