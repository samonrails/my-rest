module DocumentType
  module Event
    def self.available_values
      %w{quote invoice purchase_order packing_slip invoice_summary}
    end

    def self.quote
      "quote"
    end

    def self.invoice
      "invoice"
    end
    
    def self.invoice_summary
      "invoice_summary"
    end

    def self.purchase_order
      "purchase_order"
    end

    def self.packing_slip
      "packing_slip"
    end

    def self.vendor_documents 
      [purchase_order, packing_slip]
    end

    def self.account_documents
      [quote, invoice, invoice_summary]
    end

    def self.abbreviate type
      case type
        when DocumentType::Event::quote 
          "Q"
        when DocumentType::Event::invoice 
          "I"
        when DocumentType::Event::invoice_summary 
          "IS"
        when DocumentType::Event::purchase_order 
          "P"
        when DocumentType::Event::packing_slip 
          "S"
      end
    end
  end

  module Email
    def self.available_values
      %w{new_catering_sales catering_schedule_preview vendor_billing_summaries insurance_expiration_report}
    end

    def self.new_catering_sales
      "new_catering_sales"
    end

    def self.catering_schedule_preview
      "catering_schedule_preview"
    end

    def self.vendor_billing_summaries
      "vendor_billing_summaries"
    end

    def self.insurance_expiration_report
      "insurance_expiration_report"
    end
  end
end
