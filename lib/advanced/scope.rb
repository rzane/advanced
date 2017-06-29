module Advanced
  class Scope < Module
    def initialize(name, search)
      define_method name do |params = {}|
        search.new(all).call(params)
      end
    end
  end
end
