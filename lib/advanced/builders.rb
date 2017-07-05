module Advanced
  module Builders
    class Scope < Module
      def initialize(search, name)
        define_method name do |params = {}|
          search.new(all).call(params)
        end
      end
    end
  end
end
