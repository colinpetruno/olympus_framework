module Members
  class Finder
    def self.by_email(email)
      new(email: email).find_by_email
    end

    def self.by_email!(email)
      new(email: email).find_by_email!
    end

    def initialize(email:)
      @email = email
    end

    def find_by_email
      Member.find_by(hashed_email: hashed_email)
    end

    def find_by_email!
      Member.find_by!(hashed_email: hashed_email)
    end

    private

    attr_reader :email

    def hashed_email
      ::Portunus::Hasher.for(email)
    end
  end
end
