module Authentication::Processors
  class AskForInvite
    # NOTE: This is similar to ConnectToCompany and can probably be extracted
    # to one class.
    def self.for(oauth_response)
      new(oauth_response).process
    end

    def initialize(oauth_response)
      @oauth_response = oauth_response
    end

    def process
      create_member
    end

    def member
      @member ||= create_member
    end

    private

    attr_reader :oauth_response

    def create_member
      # TODO: We should attempt to look up the profile here first in case
      # they were manually added
      @member = ::Accounts::AddMember.add(
        {
          email: oauth_response.email.downcase,
          provider: oauth_response.provider,
          company: company,
          profile_attributes: {
            company: company,
            email: oauth_response.email.downcase.strip,
            given_name: oauth_response.given_name,
            family_name: oauth_response.family_name,
            timezone: "UTC",
            role: :basic,
            status: :pending,
            external_slug: SecureRandom.uuid,
            team: Teams::Finder.for_company(company).default
          }
        }
      )

      if @member.persisted?
        Authentication::CredentialsUpdater.for(oauth_response)
      else
        # NOTE: Shouldn't hit, this is a safety to get early indications
        # in the bug reporting system if this breaks
        raise StandardError.new("Something went wrong")
      end

      @member
    end

    def company
      @_company ||= Companies::Finder.open_for_signups(
        oauth_response.email_domain
      )
    end
  end
end
