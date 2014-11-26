
desc "Resend the last voucher object to Doc Raptor"
task :doc_raptor_voucher => :environment do 
  return unless Rails.env.development? || Rails.env.test?
  voucher_group = VoucherGroup.last
  if voucher_group 
    Sidekiq::Client.enqueue( VoucherDocumentJob, {:voucher_group_id => voucher_group.id, :document_id =>voucher_group.document.id} )
    sleep(25)
    puts AWS::private_document_url(voucher_group.document.full_file_name)
  else
    puts "You don't have any vouchers. Place a catering order."
  end
end
