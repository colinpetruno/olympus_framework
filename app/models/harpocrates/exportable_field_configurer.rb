module Harpocrates
  class ExportableFieldConfigurer
    attr_reader :field, :object

    def self.for(object, field)
      new(object: object, field: field)
    end

    def initialize(object:, field:)
      @object = object
      @field = field
    end

    def field_value(instance_object)
      if ["Symbol", "String"].include?(field.class.name)
        instance_object.send(field)
      elsif ["Hash"].include?(field.class.name)
        if field_options[:transform].present? && field_options[:transform].class.name == "Proc"
          field_options[:transform].call(
            instance_object.send(field.keys.first)
          )
        else
          instance_object.send(field.keys.first)
        end
      end
    end

    def field_options
      if ["Symbol", "String"].include?(field.class.name)
        {}
      elsif ["Hash"].include?(field.class.name)
        field[field.keys.first]
      end
    end

    def field_name
      if ["Symbol", "String"].include?(field.class.name)
        field.to_sym
      elsif ["Hash"].include?(field.class.name)
        if field_options[:attr_name].present?
          field_options[:attr_name].to_sym
        else
          field.keys.first.to_sym
        end
      end
    end

    private

    def value_for(field_type)
      if [:string].include?(field_type.to_sym)
        "DataRemoved"
      elsif [:date].include?(field_type.to_sym)
        Date.today
      elsif [:datetime].include?(field_type.to_sym)
        DateTime.now
      elsif [:integer].include?(field_type.to_sym)
        0
      else
        raise StandardError.new("unsupported type #{field_type}")
      end
    end
  end
end
