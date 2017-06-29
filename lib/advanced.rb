require 'advanced/version'
require 'advanced/search'
require 'advanced/search_form'
require 'advanced/active_record'
require 'advanced/builders/scope'

module Advanced
  def self.scope(*args)
    Advanced::Builders::Scope.new(*args)
  end
end
