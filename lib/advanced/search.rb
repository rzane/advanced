require 'pipey'
require 'advanced/definition'
require 'advanced/builders'

module Advanced
  class Search < Pipey::Chain
    extend Pipey::Steps::Scanner[/\A(search|then)_/]
    extend Pipey::Extensions::RequiredKeys
    extend Pipey::Extensions::IgnoreNil

    class << self
      def definition
        @definition ||= Definition.new
      end

      def parameter_names
        definition.parameter_names_for(self)
      end

      def use(other)
        define_method "search_#{other.name}" do |**opts|
          other.call(scope, **opts)
        end
      end

      def scope(name = :search)
        Builders::Scope.new(self, name)
      end

      def define_search(name, requirements = [], permits = [], &block)
        definition.add(requirements)
        definition.add(permits)

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

    def call(params = {})
      super(params.to_h)
    end
  end
end
