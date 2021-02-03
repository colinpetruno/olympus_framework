module ExternalResources
  class AdaptorClassLookup
    # TODO: This can probably be destroyed. It was built with one provider per
    # company but I think that is something we should not enforce at this level
    # of the application. Building it with multiple adaptors in mind provides
    # way more flexibility down the line
    #
    # TODO: This definitely can be destroyed. It is dangerous to assume that
    # only the sesion info sets the calendar
    def initialize(class_name:, session_info:)
      @class_name = class_name
      @session_info = session_info
    end

    def generate
      class_name_as_string.constantize
    end

    private

    attr_reader :class_name, :session_info

    def class_name_as_string
      class_name.gsub(
        "ExternalResources",
        session_info.provider.external_resource_base.name
      )
    end
  end
end
