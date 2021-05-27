module RadCommon
  ##
  # This is used to generate an input used for a SQL like filter
  class EqualsFilter
    attr_reader :column, :data_type

    ##
    # @param [String] column the database column that is being filtered
    # @param [Symbol] data_type controls what the input type is based on data type of column
    def initialize(column:, data_type:, scope: nil, input_label: nil)
      raise 'data_type must be either :integer or :string' if supported_data_types.exclude?(data_type)

      @column = column
      @data_type = data_type
      @scope = scope
      @input_label = input_label
    end

    def filter_view
      'equals'
    end

    def searchable_name
      equals_input
    end

    def equals_input
      "#{column}_equals"
    end

    def input_label
      @input_label || model_name
    end

    def model_name
      @input_label || column.titleize.singularize
    end

    def apply_filter(results, params)
      value = equals_value(params)
      if @scope.present?
        results = results.send(@scope, value) if value.present?
      elsif value.present?
        results = results.where("#{column} = ?", value)
      end
      results
    end

    private

      def equals_value(params)
        params[equals_input]
      end

      def supported_data_types
        %i[integer string text]
      end
  end
end
