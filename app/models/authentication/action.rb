module Authentication
  class Action
    include Routable

    def self.for(oauth_response)
      new(oauth_response)
    end

    def initialize(oauth_response)
      if oauth_response.class.name != "Authentication::OauthResponse"
        raise ::Authentication::Error.new(
          "Requires Authentication::OauthResponse"
        )
      end

      @oauth_response = oauth_response
      @session_info = oauth_response.session_info
    end

    def action_name
      @_action_name ||= determine_action
    end

    def redirect_path
      case action_name
        when :add_provider
          routes.dashboard_connections_path
        when :login
          post_connection_path(:login)
        when :connect
          post_connection_path(:connect)
        when :ask_for_invite
          routes.dashboard_company_pending_members_path
        when :create_account
          routes.dashboard_root_path
      end
    end

    def member
      @_member ||= ::Members::Finder.by_email(oauth_response.email)
    end

    private

    attr_reader :oauth_response, :session_info

    def determine_action
      if session_info.present?
        :add_provider
      else
        logged_out_action
      end
    end

    def logged_out_action
      if email_exists?
        :login
      elsif company_domain_exists? && open_for_signups?
        :connect
      elsif company_domain_exists? && inviteable?
        :ask_for_invite
      else
        :create_account
      end
    end

    def calendars
      if member.present?
        member.profile.calendars.where(provider: oauth_response.provider)
      else
        nil
      end
    end

    def post_connection_path(action)
      if action == :login
        routes.dashboard_root_path
      elsif action == :connect
        # this connects to an existing account
        routes.connect_path
      end
    end

    def email_exists?
      member.present?
    end

    def company_domain_exists?
      company.present?
    end

    def company
      @_company ||= Companies::Finder.open_for_signups(
        oauth_response.email_domain
      )
    end

    def open_for_signups?
      # enum method
      company.allowed?
    end

    def inviteable?
      # enum method
      company.invite?
    end
  end
end
