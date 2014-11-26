class VoucherDocument

  def self.create_document options
    voucher_group_id, document_id = options.values_at( "voucher_group_id", "document_id" )
    voucher_group = VoucherGroup.find( voucher_group_id )

    document_html = render_document( template_path, voucher_group )
    document_pdf = DocRaptor::build_pdf( document_html, document_file_name(voucher_group) )
    AWS::private_write document_pdf, document_file_name(voucher_group)
    document_created( document_id, voucher_group )
  end

  def self.document_file_name voucher_group
    count = voucher_group.try(:event).try(:documents).try(:count)
    "event_documents/vouchers/popup_vouchers-#{voucher_group.id}-#{count}.pdf"
  end

  def self.document_name voucher_group
    count = voucher_group.try(:event).try(:documents).try(:count)
    "popup_vouchers-#{voucher_group.id}-#{count}"
  end

  private
    def self.render_document template_path, voucher_group
      @voucher_group = voucher_group
      Haml::Engine.new(IO.read(template_path)).render(binding)
    end

    def self.document_created document_id, voucher_group
      document = Document.find(document_id)
      document.update_attributes( :status => DocumentStatus::created,
                                  :total => voucher_group.total.to_s.to_i,
                                  :name => document_name(voucher_group),
                                  :full_file_name => document_file_name(voucher_group),
                                  :voucher_group_id => voucher_group.id)
    end

    def self.template_path
      File.join(Rails.root, 'app', 'views', 'documents', 'templates', "popup_voucher.html.haml")
    end
end
