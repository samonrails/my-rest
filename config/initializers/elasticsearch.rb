if !ENV['ELASTICSEARCH_URL'] || ENV['ELASTICSEARCH_URL'].blank?
  if File.exists?("#{Rails.root}/config/elasticsearch.yml")
    ENV["ELASTICSEARCH_URL"] = YAML.load_file("#{Rails.root}/config/elasticsearch.yml")["url"]
  end
end
