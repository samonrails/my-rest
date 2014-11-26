# (C) Craig Ulliott 2011
# install a bone DRY scope into active record which facilitates searching, sorting and pagination
module SearchSortPaginate
  def self.included(base)
    
    def base.ssp_persistences params
      if !params[:ssp_persistence_action].nil?
        case params[:ssp_persistence_action]
          when "add"
            ssp_persistence_type = params[:ssp_persistence_type]
            name = params[:ssp_persistence_name]
            params.delete(:ssp_persistence_id)
            params.delete(:ssp_persistence_action)
            params.delete(:ssp_persistence_name)
            params.delete(:ssp_persistence_type)
            SspPersistence.create!(:ssp_persistence_type => ssp_persistence_type, :name => name, :parameters => params.to_query)
          when "update"
            id = params[:ssp_persistence_id]
            params.delete(:ssp_persistence_id)
            params.delete(:ssp_persistence_action)
            params.delete(:ssp_persistence_name)
            params.delete(:ssp_persistence_type)
            SspPersistence.find(id).update_attributes!(:parameters => params.to_query)
          when "delete"
            SspPersistence.destroy(params[:ssp_persistence_id]) unless (params[:ssp_persistence_id].nil? || !SspPersistence.exists?(params[:ssp_persistence_id]))
          end
      end
    end


    # a standard rails scope to wrap where, order, page and per
    # page and per are not out of the box activerecord, they are supported by the kaminari pagination gem
    def base.search_sort_paginate params, options={}

      # First, deal with the persistences
      ssp_persistences params

      # safe default options
      options = {
        :parent => nil,
        :artificial_attributes => {}
      }.merge(options)

      # the current page and number of results per page
      # - these next lines commented out by mike - being handled by Kaminari outside of SSP
      # page = params[:page] || 1
      # per_page = params[:per_page] || 30

      # create some SQL in a very DRY way
      order_sql = order_query(params, options[:artificial_attributes])

      where_sql = search_query(params, options[:parent], options[:artificial_attributes])

      # excecute the query
      # - this next line commented out by mike - being handled by Kaminari outside of SSP
      # where(where_sql).order(order_sql).page(page).per(per_page)
      where(where_sql).order(order_sql)
    end


    # the order query, if the selected column is an artificial attribute then the raw sql will be used
    def base.order_query params, artificial_attributes={}
      artificial_attributes = HashWithIndifferentAccess.new(artificial_attributes)

      # the colum we going to sort by, with a sanity check
      sort_column = params[:sort].present? ? params[:sort] : 'id'
      raise 'invalid sort_column' unless sort_column.match(/^[a-z]+[a-z0-9_]*[a-z0-9]+$/)

      # the direction we are sorting by
      sort_direction =  %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"

      # if we are sorting by a virtual column, then we use a sub query
      artificial_attributes.key?(sort_column) ? "(#{artificial_attributes[sort_column]}) #{sort_direction}" : "#{self.name.underscore.pluralize}.#{sort_column} #{sort_direction}"

    end

    # the search query, if the selected column is an artificial attribute then the raw sql will be used
    def base.search_query params, parent_model=nil, artificial_attributes={}

      search_params = HashWithIndifferentAccess.new(params[:searchable])
      artificial_attributes = HashWithIndifferentAccess.new(artificial_attributes)

      sqls = []

      # itterate over the hash representation of the searh fields for this model
      self.all_possible_search_fields(parent_model).each do |field| 

        # the name of the models attribute or artificial_attribute we are searching by
        # can be set with the 'field' option else it is assumed to be the name
        field_name = field[:name].to_sym

        # if this is an artificial_attribute, the field_name will be an sql subquery not a column name
        sql_field_name = artificial_attributes.key?(field_name) ? "(#{artificial_attributes[field_name]})" : (field[:field] || field[:name])

        # if there is no "." in the field name, then we assume the table being referenced is the table for the current model type
        sql_field_name = "#{self.name.underscore.pluralize}.#{sql_field_name}" unless sql_field_name.match(/\.|`/)

        # ranges have a _from and _to which are passed in from the client
        from_field_name = (field_name.to_s+'_from').to_sym
        to_field_name = (field_name.to_s+'_to').to_sym

        # Default the range to be 14 days if one of more of the dates is not provided
        if [:daterange, :datetimerange].include? field[:as]
          if (search_params[from_field_name].nil? || search_params[from_field_name].empty?) && (search_params[to_field_name].nil? || search_params[to_field_name].empty?)
            search_params[from_field_name] = (Date.today-7).strftime("%d %B %Y"); search_params[to_field_name] = (Date.today+14).strftime("%d %B %Y")
          elsif search_params[from_field_name].nil? || search_params[from_field_name].empty?
            search_params[from_field_name] = (Date.parse(search_params[to_field_name])-14).strftime("%d %B %Y")
          elsif search_params[to_field_name].nil? || search_params[to_field_name].empty?
            search_params[to_field_name] = (Date.parse(search_params[from_field_name])+14).strftime("%d %B %Y")
          end
        end

        # if the key is not present in the search params, then we can use a default value
        # this is relevant  only when the search form is first loaded, and subsequent requests have
        # all keys, even if their values are blank - this is desired functionality
        unless search_params.key? field_name
          search_params[field_name] = field[:default] if field[:default]
        end

        # do we have any values (including a default) for this field, if we dont then it can be completely skipped
        unless search_params[field_name].present? or search_params[from_field_name].present? or search_params[to_field_name].present? 
          next
        end

        # what type of search is this
        case field[:as] 
          when :string
            # string searches can be across multiple columns, this is accomplished by using the "fields" option
            # if we dont have "fields", then we default to the field_name
            sqls << ( field[:fields] ? field[:fields] : [sql_field_name] ).collect{|f| 

              # if there is no "." in the field name, then we assume the table being referenced is the table for the current model type
              sql_f = f.match(/\./) ? f : "#{self.name.underscore.pluralize}.#{f}"
              if field[:wildcard]
                case field[:wildcard].to_sym
                  when :left
                    ActiveRecord::Base.send(:sanitize_sql_array, ["#{sql_f} ilike '%s'", "%#{search_params[field_name]}" ])
                  when :right
                    ActiveRecord::Base.send(:sanitize_sql_array, ["#{sql_f} ilike '%s'", "#{search_params[field_name]}%" ])
                  when :both
                    ActiveRecord::Base.send(:sanitize_sql_array, ["#{sql_f} ilike '%s'", "%#{search_params[field_name]}%" ])
                end
              else
                ActiveRecord::Base.send(:sanitize_sql_array, ["#{sql_f} ilike '%s'", "#{search_params[field_name]}" ])
              end
            }.join(' or ')

          when :range
            if search_params[from_field_name].present?
              sqls << ActiveRecord::Base.send(:sanitize_sql_array, ["#{sql_field_name} >= '%s'", (search_params[from_field_name])])
            end
            if search_params[to_field_name].present?
              sqls << ActiveRecord::Base.send(:sanitize_sql_array, ["#{sql_field_name} <= '%s'", (search_params[to_field_name])])
            end

          when :daterange
            sqls << ActiveRecord::Base.send(:sanitize_sql_array, ["#{sql_field_name} between '%s' and '%s'", (
                search_params[from_field_name].present? ? ("#{search_params[from_field_name]} 00:00:00".to_datetime-Time.now.utc_offset.seconds).to_s(:db) : '0001-01-01'
              ), (
                search_params[to_field_name].present? ? ("#{search_params[to_field_name]} 23:59:59".to_datetime-Time.now.utc_offset.seconds).to_s(:db) : '9999-01-01'
            )])

          when :datetimerange
            sqls << ActiveRecord::Base.send(:sanitize_sql_array, ["#{sql_field_name} between '%s' and '%s'", (
                search_params[from_field_name].present? ? (search_params[from_field_name].to_datetime-Time.now.utc_offset.seconds).to_s(:db) : '0001-01-01'
              ), (
                search_params[to_field_name].present? ? (search_params[to_field_name].to_datetime-Time.now.utc_offset.seconds).to_s(:db) : '9999-01-01'
            )])

          when :select
            sqls << ActiveRecord::Base.send(:sanitize_sql_array, ["#{sql_field_name} = '%s'", "#{search_params[field_name]}" ])

          when :multi_select
            choices = search_params[field_name].reject!(&:empty?) || search_params[field_name]
            if choices.count > 0
              in_clause = choices.join("','")
              # sqls << ActiveRecord::Base.send(:sanitize_sql_array, ["#{sql_field_name} in ('%s')", "#{in_clause}"])
              # somehow sanitize this
              sqls << "#{sql_field_name} in ('" + in_clause + "')"
            end

          when :boolean
            if search_params[field_name] == '1'
              sqls << "#{sql_field_name} = 1 or (#{sql_field_name} != 0 and #{sql_field_name} is not null)"
            else
              sqls << "#{sql_field_name} = 0 or #{sql_field_name} is null"
            end

        end

      end

      # if there were no search queies, then return nil
      if sqls.empty?
        return nil
      end

      # build into one query
      return '('+sqls.join(') and (')+')'
    end
    
  end
end
  
