module Harpocrates
  class FieldExporter
    def self.for(object)
      new(object: object).as_json
    end

    def initialize(object:)
      @object = object
    end

    def as_json(_opts={})
      object.class.attr_exportable_fields.inject({}) do |hash, field|
        hash[field.field_name] = field.field_value(object)
        hash
      end
    end

    private

    attr_reader :object
  end
end
