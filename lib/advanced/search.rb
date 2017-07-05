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

      def use(other)
        define_method "search_#{other.name}" do |**opts|
          other.new(scope).call(**opts)
        end
      end

      def scope(name = :search)
        Builders::Scope.new(self, name)
      end

      def define_search(name, requirements = [], permits = [], &block)
        definition.add_parameters(requirements)
        definition.add_parameters(permits)

        define_method "search_#{name}" do |**opts|
          if requirements.all? { |k| opts[k] }
            instance_exec(
              *opts.values_at(*requirements),
              *opts.values_at(*permits),
              &block
            )
          end
        end
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
