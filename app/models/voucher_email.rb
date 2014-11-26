class VoucherEmail
  #TODO module this.
  def self.send_voucher_email params
    voucher_group = VoucherGroup.find(params["voucher_group_id"])
    Sidekiq::Client.enqueue(OrderConfirmationMails, voucher_group.order_id, voucher_group.purcashed_by_id)
  end
end
