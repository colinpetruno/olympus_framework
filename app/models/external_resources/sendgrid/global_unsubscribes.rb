module ExternalResources
  module Sendgrid
    class GlobalUnsubscribes

      def add_emails(emails)
        client.
          asm.
          suppressions.
          global.
          post(
            {
              request_body: {
                recipient_emails: emails
              }
            }
          )
      end

      def remove_email(email)
        client.
          asm.
          suppressions.
          global.
          send(email.to_sym).
          delete
      end

      private

      def client
        ::ExternalResources::Sendgrid::Client.new.client
      end
    end
  end
end
