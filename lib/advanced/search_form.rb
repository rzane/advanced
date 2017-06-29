require 'active_support/core_ext/object/blank'

module Advanced
  class SearchForm
    begin
      require 'active_model'
      include ActiveModel::Model
    rescue LoadError
    end

    def self.parameter_names
      @parameter_names ||= []
    end

    def self.parameter(*names)
      names.flatten.each do |name|
        parameter_names << name
        attr_accessor name
      end
    end

    # We know exactly what parameters are whitelisted,
    # so, we can skip by AC::Parameters.
    def initialize(opts = nil)
      if opts.respond_to? :to_unsafe_h
        super opts.to_unsafe_h
      else
        super
      end
    end

    def blank?
      to_h.blank?
    end

    # Pull out the blank values. Recursively check if the
    # resulting object responds to #to_search_h, as this
    # would indicate a SearchForm object.
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
