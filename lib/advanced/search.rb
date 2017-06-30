require 'forwardable'
require 'advanced/definition'
require 'advanced/builders'

module Advanced
  class Search < SimpleDelegator
    class << self
      def definition
        @definition ||= Definition.new(self)
      end

      def parameter_names
        definition.parameter_names
      end

      def form
        Builders::Form.new(self)
      end

      def search
        Builders::Search.new(self)
      end

      def scope(name = :search)
        Builders::Scope.new(self, name)
      end
    end

    alias scope __getobj__

    def steps
      self.class.definition.steps
    end

    # Because we're going to __setobj__, it's probably a good
    # idea to clone this, just incase someone is using it like
    # a singleton.
    def call(params = {})
      clone.call!(params)
    end

    def call!(params = {}) # private
      params = params.to_h

      steps.reverse_each do |name, requirements|
        if requirements.all? { |k| params[k] }
          result = public_send(name, params)
          __setobj__(result) if result
        end
      end

      scope
    end
  end
end
