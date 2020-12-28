module Ichnaea
  class Hasher
    def self.for(string)
      Digest::SHA2.new(256).hexdigest(string)
    end

    def self.for_uri(uri)
      Digest::SHA2.new(256).hexdigest([uri.hostname, uri.path].join(""))
    end

    def self.for_utms(utms)
      hash_string = [
        "utm_source=#{utms["utm_source"]}",
        "utm_medium=#{utms["utm_medium"]}",
        "utm_campaign=#{utms["utm_campaign"]}",
        "utm_term=#{utms["utm_term"]}",
        "utm_content=#{utms["utm_content"]}",
      ].join("&")

      Digest::SHA2.new(256).hexdigest(hash_string)
    end

    def self.for_hash(hash)
      sorted_values = hash.collect{ |k,v| [k,v] }.sort{ |a,b| a[0] <=> b[0] }
      Digest::SHA2.new(256).hexdigest(Marshal::dump(sorted_values))
    end
  end
end
