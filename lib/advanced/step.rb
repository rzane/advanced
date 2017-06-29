require 'active_support/core_ext/hash/slice'

module Advanced
  class Step
    class InvalidError < StandardError
    end

    PATTERN = /\A(search|then)_/

    def self.extract(meth)
      step = new(meth.name, meth.parameters)

      if step.invalid_types.any?
        raise InvalidError, "The signature for ##{step.name} must only use keyword arguments."
      end

      step
    end

    attr_reader :name, :requires, :permits, :names, :types

    def initialize(name, keys = [])
      @name     = name
      @types    = keys.map(&:first)
      @names    = keys.map(&:last)
      @requires = grab(keys, :keyreq)
      @permits  = grab(keys, :key)
    end

    def all?
      types.include? :keyrest
    end

    def none?
      types.empty?
    end

    def invalid_types
      types - [:key, :keyreq, :keyrest]
    end

    def slice(params)
      return :none if none?

      values = params.slice(*requires)

      return :invalid if values.length != requires.length
      return params if all?

      values.merge params.slice(*permits)
    end

    private

    def grab(keys, type)
      keys.select { |k, _| k == type }.map(&:last)
    end
  end
end
