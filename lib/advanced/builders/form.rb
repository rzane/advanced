module Advanced
  module Builders
    class Form < Module
      def initialize(search)
        define_singleton_method :included do |base|
          base.attributes(search.parameter_names)
        end
      end
    end
  end
end
