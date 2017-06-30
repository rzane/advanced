module Advanced
  module ActiveRecord
    module DSL
      def where_eq(param, column: param)
        define_search param, [param] do |value|
          where column => value
        end
      end

      def where_any_eq(param, column: param)
        define_search param, [param] do |value|
          values = values.reject(&:blank?)
          where column => values if values.any?
        end
      end

      def where_lt(param, column: param)
        define_search param, [param] do |value|
          where(arel_table[column].lt(value))
        end
      end

      def where_gt(param, column: param)
        define_search param, [param] do |value|
          where(arel_table[column].gt(value))
        end
      end
    end
  end
end
