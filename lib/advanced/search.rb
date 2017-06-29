require 'forwardable'
require 'active_support/core_ext/hash/slice'
require 'advanced/step'
require 'advanced/builders/form'
require 'advanced/builders/search'

module Advanced
  class Search < SimpleDelegator
    class << self
      def steps
        @steps ||= compile
      end

      def properties
        @properties ||= []
      end

      def property(name)
        properties << name
      end

      def parameter_names
        steps.flat_map(&:parameter_names) + properties
      end

      def form
        Builders::Form.new(self)
      end

      def search
        Builders::Search.new(self)
      end

      private

      def compile
        instance_methods.grep(Step::PATTERN).reverse.map do |m|
          Step.from_method(instance_method(m))
        end
      end
    end

    alias scope __getobj__
    alias scope= __setobj__

    def call(params = {})
      clone.call!(params)
    end

    def call!(params = {}) # private
      params = params.to_h

      self.class.steps.each do |step|
        result = run_step(step.name, step.slice(params))
        self.scope = result if result
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
