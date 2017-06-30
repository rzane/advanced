module Advanced
  class Definition
    PATTERN = /\A(search|then)_/

    KEY_TYPES     = %i[key keyreq]
    KEY_REQ_TYPES = %i[keyreq]

    def initialize(klass)
      @klass = klass
      @additional_parameter_names = []
    end

    def add_parameters(keys = [])
      @additional_parameter_names += keys
    end

    def steps
      search_methods.map do |meth|
        [meth.name, grab(meth.parameters, KEY_REQ_TYPES)]
      end
    end

    def parameter_names
      values = search_methods.flat_map do |meth|
        grab(meth.parameters, KEY_TYPES)
      end

      values.to_a + @additional_parameter_names
    end

    private

    def search_methods
      @klass.instance_methods.lazy.grep(PATTERN).map do |name|
        @klass.instance_method(name)
      end
    end

    def grab(params, keys)
      params.reduce([]) do |acc, (type, name)|
        keys.include?(type) ? acc + [name] : acc
      end
    end
  end
end
