module Advanced
  class Definition
    KEY_TYPES = %i[key keyreq]

    def initialize
      @names = []
    end

    def add(names = [])
      @names += names
    end

    def parameter_names_for(klass)
      values = klass.steps.flat_map do |meth|
        klass.instance_method(meth).parameters.reduce([]) do |acc, (type, name)|
          KEY_TYPES.include?(type) ? (acc + [name]) : acc
        end
      end

      values + @names
    end
  end
end
