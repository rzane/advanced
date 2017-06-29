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
  end
end
