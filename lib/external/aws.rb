module AWS

  #Create a url with the default second time window in the default private bucket.
  def self.private_document_url file
    return "" if file.nil?
    private_bucket.files.new(key: file).url(Time.now + AWS::PrivateWindow.to_i )
  end

  def self.private_write resource, name
    private_bucket.files.create(key: name, 
                                body: resource,
                                public: false)
  end

  private

    def self.private_bucket
      connection.directories.new( key: AWS::PrivateBucket, 
                                  public: false)
    end

    def self.connection
      Fog::Storage.new( { provider: "AWS", 
                          aws_access_key_id: AWS::Key, 
                          aws_secret_access_key: AWS::Secret})
  end
end