require 'active_support/core_ext/object/blank'

module Advanced
  class Step
    PATTERN = /\A(search|then)_/

    def self.from_method(m)
      keys = Hash.new { |h, k| h[k] = [] }

      m.parameters.each do |type, name|
        case type
        when :keyreq
          keys[:requires] << name
        when :key
          keys[:permits] << name
        when :keyrest
          keys[:all] = true
        end
      end

      keys[:none] = m.parameters.empty?

      new(m.name, keys)
    end

    attr_reader :name, :requires, :permits

    def initialize(name, requires: [], permits: [], all: false, none: false)
      @name     = name
      @requires = requires
      @permits  = permits
      @all      = all
      @none     = none
    end

    def parameter_names
      @permits + @requires
    end

    def all?
      @all
    end

    def none?
      @none
    end

    def slice(params)
      return :none if none?

      values = params.slice(*requires)

      return :invalid if values.length != requires.length
      return params if all?

      values.merge params.slice(*permits)
    end
  end
end
