module VoucherDocumentJob
  @queue = :documents

  def self.perform options={}
    VoucherDocument.create_document( options )
    # VoucherEmail.send_voucher_email( options )
    Rails.logger.info "Create Vouchers for Voucher: #{options[:voucher_group_id]} and Document: #{options[:document_id]}."
  end
end