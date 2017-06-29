module Advanced
  module ActiveRecord
    def where_eq(param, column: param)
      defsearch(param) do |value|
        where column => value
      end
    end

    def where_any_eq(param, column: param)
      defsearch(param) do |values|
        values = values.reject(&:blank?)
        where column => values if values.any?
      end
    end

    def where_lt(param, column: param)
      defsearch(param) do |value|
        where(arel_table[column].lt(value))
      end
    end

    def where_gt(param, column: param)
      defsearch(param) do |value|
        where(arel_table[column].gt(value))
      end
    end

    private

    def defsearch(param, &block)
      property(param)

      define_method "search_#{param}" do |**opts|
        instance_exec(opts[param], &block) if opts[param]
      end
    end
  end
end
