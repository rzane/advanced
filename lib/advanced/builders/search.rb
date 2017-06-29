module Advanced
  module Builders
    class Search < Module
      def initialize(search)
        define_method "search_#{search.name}" do |**opts|
          search.new(scope).call(**opts)
        end
      end
    end
  end
end
