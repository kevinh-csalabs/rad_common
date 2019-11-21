module RadCommon
  class Search

    attr_reader :params, :current_user

    def initialize(query:, filters:, sort_columns: nil, current_user:, params:)
      @results = query
      @current_user = current_user
      @params = params
      @filters = Filters.new(filters: filters, search: self)
      FilterDefaulting.apply_defaults(current_user, self)
      @sorts = Sorts.new(sort_columns: sort_columns, search: self)
    end

    def results
      retrieve_results
    end

    def search_params?
      params.has_key? :search
    end

    def search_params
      search_params? ? params.require(:search).permit(permitted_searchable_columns) : {}
    end

    def blank?(column)
      val = selected_value(column)
      val.is_a?(Array) ? val.all?(&:blank?) : val.blank?
    end

    def selected_value(column)
      search_params[column]
    end

    def searchable_columns_strings
      searchable_columns.map(&:to_s)
    end

    private

      def retrieve_results
        @results = @filters.apply_filtering(@results)
        @results = @sorts.apply_sorting(@results)
      end

      def searchable_columns
        filters.map(&:searchable_name)
      end

      def permitted_searchable_columns
        # we need to make sure any params that are an array value ( multiple select ) go to the bottom for permit to work
        columns = @filters.sort_by { |f| f.respond_to?(:multiple) && f.multiple ? 1 : 0 }
        columns.map { |f|
          if f.respond_to?(:multiple) && f.multiple
            hash = {}
            hash[f.searchable_name] = []
            hash
          else
            f.searchable_name
          end
        }.flatten
      end
  end
end
