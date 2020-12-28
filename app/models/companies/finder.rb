module Companies
  class Finder
    def self.by_domain(domain)
      new(domain: domain).by_domain
    end

    def self.open_for_signups(domain)
      new(domain: domain).open_for_signups
    end

    def initialize(domain: nil)
      @domain = domain
    end

    def by_domain
      Company.find_by(hashed_email_domain: Portunus::Hasher.for(domain))
    end

    def by_domain!
      Company.find_by!(hashed_email_domain: Portunus::Hasher.for(domain))
    end

    def open_for_signups
      Company.
        where(open_signups: [:invite, :allowed]).
        find_by(hashed_email_domain: Portunus::Hasher.for(domain))
    end

    private

    attr_reader :domain
  end
end
