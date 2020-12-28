module Utilities
  class DomainFromEmail
    def self.for(email)
      new(email).domain
    end

    def initialize(email)
      @email = email
    end

    def domain
      email.split("@").last
    end

    private

    attr_accessor :email
  end
end
