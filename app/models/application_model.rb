class ApplicationModel < ActiveRecord::Base
  
  # Do NOT remove this line, it is required!
  self.abstract_class = true

  public

    def get_cache_counter_key
      self.class.name + '_cc'
    end
    
    def inc_cache_counter(recursive = true)
      cache_key = self.get_cache_counter_key
      if (value = Rails.cache.read(cache_key)).nil?
        Rails.cache.write(cache_key, (value = 0), expires_in: 1.week)
      else
        Rails.cache.write(cache_key, (value = value + 1), expires_in: 1.week)
      end
      # Increment all Model associations non-recursively
      if recursive
        [:belongs_to, :has_and_belongs_to_many].each do |association|
          self.class.reflect_on_all_associations(association).each do |associated_model|
            associated_model_class = associated_model.name.to_s.singularize.camelize
            associated_model_class.constantize.new.inc_cache_counter(false) if self.class_exists?(associated_model_class)
          end
        end
      end
      value
    end

    def get_cache_counter
      cache_key = self.get_cache_counter_key
      if (value = Rails.cache.read(cache_key)).nil?
        value = self.inc_cache_counter(false)
      end
      value      
    end

    def class_exists?(class_name)
      this_class = Module.const_get(class_name)
      return this_class.is_a?(Class)
      rescue NameError
        return false
    end    

end