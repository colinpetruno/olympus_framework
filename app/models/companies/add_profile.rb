module Companies
  class AddProfile
    def self.for(email, session_info, internal=true, attributes={})
      new(email, session_info, attributes).add
    end

    def initialize(email, session_info, internal=true, attributes={})
      @attributes = attributes
      @email = email
      @internal = internal
      @session_info = session_info
    end

    def add
      return true if profile_exists? && internal_profile?(profile)

      if internal == true
        session_info.company.profiles.create(
          email: email,
          company: session_info.company,
          given_name: attributes[:given_name] || "n/a",
          family_name: attributes[:family_name] || "n/a",
        )
      else
        ExternalProfile.create(
          email: email,
          name: attributes[:full_name]
        )
      end
    end

    private

    attr_reader :attributes, :email, :session_info, :internal

    def internal_profile?(profile)
      company_domain == ::Utilities::DomainFromEmail.for(profile.email)
    end

    def company_domain
      @_company_domain ||= session_info.company.email_domain
    end

    def profile_exists?
      profile_finder.for_email(email).present?
    end

    def profile_finder
      @_profile_finder ||= ::Profiles::Finder.
        for(session_info)
    end
  end
end
