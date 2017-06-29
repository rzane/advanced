module Advanced
  module Builders
    class Form < Module
      # Copy the parameters over to the form
      def initialize(search)
        define_singleton_method :included do |base|
          search.parameter_names.each do |name|
            base.parameter(name)
          end
        end
      end
    end

    class Search < Module
      def initialize(search)
        define_method "search_#{search.name}" do |**opts|
          search.new(scope).call(**opts)
        end
      end
    end

    class Scope < Module
      def initialize(search, name)
        define_method name do |params = {}|
          search.new(all).call(params)
        end
      end
    end
  end
end
