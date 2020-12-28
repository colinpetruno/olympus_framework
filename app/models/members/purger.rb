module Members
  class Purger
    def self.for(member)
      new(member).purge
    end

    def initialize(member)
      @member = member
    end

    def purge
      disconnect_account

      # TODO: Finish me...
      AccountDeletion.where(profile: profiles).destroy_all
      Addresses.where(addressable: profiles).destroy_all
      Addresses.where(addressable: member).destroy_all
      AuthCredentialLog.where(member: member).destroy_all
    end

    private

    attr_reader :member

    def profiles
      [member.profile]
    end

    def disconnect_account
      AuthCredential.where(member: member).each do |auth_credential|
        Authentication::Revoker.for(auth_credential)

        auth_credential.destroy!
      end
    end
  end
end
