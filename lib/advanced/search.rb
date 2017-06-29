require 'forwardable'
require 'advanced/step'
require 'advanced/builders'

module Advanced
  class Search < SimpleDelegator
    class << self
      def steps
        @steps ||= instance_methods.grep(Step::PATTERN).reverse.map do |m|
          Step.extract(instance_method(m))
        end
      end

      def parameter_names
        @parameter_names ||= steps.flat_map(&:names)
      end

      def parameter(name)
        parameter_names << name
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

    # Because we're going to __setobj__, it's probably a good
    # idea to clone this, just incase someone is using it like
    # a singleton.
    def call(params = {})
      clone.call!(params)
    end

    def call!(params = {}) # private
      params = params.to_h

      self.class.steps.each do |step|
        result = run_step(
          step.name,
          step.slice(params)
        )

        __setobj__(result) if result
      end

      scope
    end

    private

    def run_step(name, opts)
      case opts
      when :invalid
        # missing required params, skip
      when :none
        public_send(name)
      else
        public_send(name, opts)
      end
    end
  end
end
