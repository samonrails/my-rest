class Elasticsearch::Reindex
  include Sidekiq::Worker
  sidekiq_options :queue => :default, :retry => 3

  sidekiq_retries_exhausted do |msg|
    Sidekiq.logger.warn "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
  end

  def perform model_to_reindex, id
    model_to_reindex.constantize.find(id).try(:reindex)
  end
end
