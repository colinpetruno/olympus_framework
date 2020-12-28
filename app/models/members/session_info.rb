module Members
  class SessionInfo
    attr_reader :member

    def self.for(member)
      new(member: member)
    end

    def self.by_id(id)
      new(member: Member.find(id))
    end

    def self.by_syncable(syncable)
      if syncable.class.name == "Calendar"
        new(member: Member.find(syncable.profile.member_id))
      elsif syncable.class.name == "Member"
        new(member: syncable)
      elsif syncable.class.name == "AuthCredential"
        new(member: Member.find(syncable.member_id))
      end
    end

    def self.by_sync_subscription(subscription)
      if subscription.subscribeable_type == "Calendar"
        new(member: Member.find(subscription.subscribeable.profile.member_id))
      elsif subscription.subscribeable_type == "AuthCredential"
        new(member: Member.find(subscription.subscribeable.member_id))
      end
    end

    def initialize(member:)
      @member = member
    end

    def account
      @_account ||= company.account
    end

    def company
      @_company ||= member.company
    end

    def profile
      @_profile ||= member.profile
    end

    def provider
      @_provider ||= ::Companies::Provider.new(company: company)
    end

    def provider_name
      provider.provider
    end

    def provider_credential
      @_provider_credential ||= Members::ProviderCredentials.for(member)
    end

    def broken_connections?
      @_broken_connections ||= BrokenAuthRecord.
        where(member_id: member.id, reconnected_at: nil).
        exists?
    end
  end
end
