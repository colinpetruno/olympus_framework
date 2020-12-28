class ApplicationPolicy
  attr_reader :session_info, :record
  def initialize(session_info, record)
    raise Pundit::NotAuthorizedError, "must be logged in" unless session_info
    @record = record
    @session_info = session_info
  end

  class Scope
    attr_reader :session_info, :scope

    def initialize(session_info, scope)
      raise Pundit::NotAuthorizedError, "must be logged in" unless session_info
      @scope = scope
      @session_info = session_info
    end
  end
end
