module Profiles
  class Finder
    include Pagy::Backend

    def self.for(session_info)
      new(session_info)
    end

    def initialize(session_info)
      @session_info = session_info
    end

    def for_email(email, options={})
      profile = session_info.
        company.
        profiles.
        where("deleted_at is null").
        find_by(hashed_email: ::Portunus::Hasher.for(email))

      if options[:external] == true && profile.blank?
        ExternalProfile.find_by(hashed_email: ::Portunus::Hasher.for(email))
      else
        profile
      end
    end

    def by_id(id)
      Profile.find(id)
    end

    def pending_for_company
      session_info.
        company.
        profiles.
        includes(:data_encryption_key).
        where(status: :pending).
        where("deleted_at is null")
    end

    def for_company_and_id(id)
      for_company.find(id)
    end

    def for_company
      session_info.
        company.
        profiles.
        includes(:data_encryption_key).
        where(status: :active).
        where("deleted_at is null")
    end

    def for_company_paginated(page: 1, offset: 20)
      pagy(for_company, items: offset, page: page)
    end

    def for_session
      session_info.profile
    end

    private

    attr_reader :session_info

    def params
      # for pagy...
      {}
    end
  end
end
