module ExternalResources
  class Base
    def initialize(session_info:, options: {})
      @session_info = session_info

      if respond_to?(:default_options)
        @options = default_options.deep_merge(options)
      else
        @options = options
      end
    end

    private

    attr_reader :session_info

    def company
      sesion_info.company
    end

    def member
      session_info.member
    end

    def adaptor_class
      AdaptorClassLookup.new(
        class_name: self.class.name,
        session_info: session_info
      ).generate
    end

    def adaptor
      @_adaptor ||= adaptor_class.new(
        session_info: session_info
      )
    end
  end
end
