module Advanced
  module ActiveRecord
    module DSL
      def where_eq(param, column: param)
        define_search param, [param] do |value|
          where column => value
        end
      end

      def where_any_eq(param, column: param)
        define_search param, [param] do |values|
          values = values.reject(&:blank?)
          where column => values if values.any?
        end
      end

      def where_lt(*args)
        where_arel(:lt, *args)
      end

      def where_gt(*args)
        where_arel(:gt, *args)
      end

      def where_lteq(*args)
        where_arel(:lteq, *args)
      end

      def where_gteq(*args)
        where_arel(:gteq, *args)
      end

      private

      def where_arel(meth, param, column: param)
        define_search param, [param] do |value|
          where(arel_table[column].send(meth, value))
        end
      end
    end
  end
end
