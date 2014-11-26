module Fooda
  module Search
    extend ActiveSupport::Concern

    included do
      class_attribute :search_filter_helper,
                      :search_filter_columns

      self.search_filter_helper = to_s.downcase.pluralize

      begin
        self.search_filter_columns = self.columns.select do |column|
          column.type == :string || column.type == :text
        end.map(&:name).map(&:to_sym)
      rescue
        Rails.logger.error "Error configuring Fooda::Search on #{ self.class.to_s }: #{ $! }"
      end
    end

    # Each model which uses this mixin
    # can define their own method with the
    # attributes they want to be available
    # in the search results page.  view expects
    # to have a heading, and preview attribute
    def to_search_result
      {heading:to_s,preview:to_s,id:self.id,model:self.class.to_s}
    end

    module ClassMethods
      # Note
      # Figure out how to use Squeel predicate methods
      # on dynamic columns. send(column) inside the where { } block isn't working
      def perform_search query, options={}
        queries = []
        bind_variables = []

        search_filter_columns.each do |column|
          # If the user has typed in an integer, then assume they are
          # looking for an exact match.  This is because the user is
          # looking for an exact ID.
          if query.to_i.to_s == query
             # Exact
            queries << "#{ column } = ?"
            bind_variables << "#{ query }"
          else
            # Partial
            queries << "#{ column } ilike ?"
            bind_variables << "%#{ query }%"
          end
        end

        results = where(queries.join(" OR "), *bind_variables)
      end

      def global_site_search *args
        options = args.extract_options!

        if options[:filter]
          self.search_filter_helper = options[:filter]
        end

        if options[:on]
          self.search_filter_columns = Array(options[:on]).map(&:to_sym)
        end
      end
    end

  end
end

module Fooda::Search
  class << self
    attr_accessor :models, :configured
  end

  self.models = []
  self.configured = false

  def self.perform query, options={}
    raise "Attempt to perform search without configuring.  Did you add an initializer?" unless self.configured == true

    filter = options[:filter]

    search_targets = self.models.reject do |klass|
      filter && klass.search_filter_helper != filter
    end

    results = search_targets.inject([]) do |results,search_target|
      results += Array(search_target.perform_search(query))
      results
    end

    results.map(&:to_search_result)
  end

  def self.configure options={}
    self.configured = true

    self.models += Array(options[:models]).map do |model|
      klass = model.to_s.constantize

      unless klass.respond_to?(:global_site_search)
        raise "#{ model.to_s } does not implement Fooda::Search"
      end

      klass
    end

    self.models.uniq!
  end
end
