module Authentication
  module Processors
    class AccountCreator
      def self.for(oauth_response)
        new(oauth_response).create
      end

      def initialize(oauth_response)
        @oauth_response = oauth_response
      end

      def create
        # create the required records for the member login
        result = Accounts::Creator.for({
          member: {
            email: oauth_response.email.downcase,
            provider: oauth_response.provider,
            profile_attributes: {
              email: oauth_response.email.downcase.strip,
              given_name: oauth_response.given_name,
              family_name: oauth_response.family_name,
              timezone: "UTC"
            }
          },

          company: {
            email_domain: oauth_response.email_domain,
            name: I18n.t("defaults.application.company_name"),
            auth_credential_id: nil,
            open_signups: :disabled,
            provider: oauth_response.provider
          }
        })


        if result[:member].persisted?
          Authentication::CredentialsUpdater.for(oauth_response)

          # giving errrors so commentout, please confirm is there any other use or it was calendar synchronization part - kamal
          # ::Syncs::Queuer.new(
          #  ::Members::SessionInfo.for(result[:member])
          # ).queue(
          #  result[:member].auth_credentials.first
          # )
          # if its a new one then we should queue a calendar sync
          #
          return { company: result[:company],  member: result[:member] }
        else
          return { errors: result[:member].errors.full_messages }
        end
      end

      private

      attr_reader :oauth_response
    end
  end
end
