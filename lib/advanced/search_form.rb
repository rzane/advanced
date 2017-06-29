require 'set'
require 'active_support/core_ext/object/blank'
require 'active_model'

module Advanced
  class SearchForm
    include ActiveModel::Model

    def self.parameter_names
      @parameter_names ||= []
    end

    def self.attribute(name)
      self.parameter_names << name
      attr_accessor name
    end

    def self.attributes(*names)
      names.flatten.each do |name|
        attribute(name)
      end
    end

    def initialize(opts)
      if opts.respond_to? :to_unsafe_h
        super opts.to_unsafe_h
      else
        super
      end
    end

    def blank?
      to_h.blank?
    end

    def to_search_h
      self.class.parameter_names.reduce({}) do |acc, key|
        value = public_send(key)
        value = value.to_search_h if value.respond_to?(:to_search_h)
        value = value.presence
        value ? acc.merge(key => value) : acc
      end
    end
    alias to_h to_search_h
  end
end
