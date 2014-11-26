class DocRaptor

  def self.build_pdf document_html, name
    response = DocRaptor.create(document_content: document_html, 
                                name: name, 
                                document_type: "pdf",
                                strict: "none",
                                test: (!Rails.env.production? and !Rails.env.staging?))
    raise "DocRaptor Error: #{response.code}" if response.code != 200
    response
  end

  def self.build_xls document_html, name
    raise "Not yet implimented"
  end
end