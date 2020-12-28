module AuthCredentials
  class Status
    attr_reader :auth_credential, :broken_auth_record, :provider

    def initialize(provider:, auth_credential:, broken_auth_record: nil)
      @auth_credential = auth_credential
      @broken_auth_record = broken_auth_record
      @provider = provider
    end

    def active?
      auth_credential.present? && broken_auth_record.blank?
    end

    def disconnected?
      broken_auth_record.present?
    end

    def inactive?
      !active?
    end

    def status
      if active?
        :active
      elsif disconnected?
        :disconnected
      else
        :never_connected
      end
    end
  end
end
