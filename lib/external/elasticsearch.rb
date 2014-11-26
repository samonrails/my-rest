module Elasticsearch
  
  def self.reindex model_to_reindex, id
     Elasticsearch::Reindex.perform_async(model_to_reindex, id)
  end
end