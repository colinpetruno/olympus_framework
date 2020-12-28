module Ichnaea
  class IpMasker
    def self.mask(ip_address)
      ip_addr = IPAddr.new(ip_address)

      if ip_addr.ipv4?
        ip_addr.mask(24).to_s
      else
        ip_addr.mask(48).to_s
      end
    end
  end
end
