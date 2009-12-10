module Domainatrix
  class DomainParser
    attr_reader :tlds

    def initialize(file_name)
      @tlds = {}
      read_dat_file(file_name)
    end

    def read_dat_file(file_name)
      File.readlines(file_name).each do |line|
        line = line.strip
        unless line.start_with? "//" || line.empty?
          parts = line.split(".").reverse

          sub_hash = @tlds
          parts.each do |part|
            sub_hash = (sub_hash[part] ||= {})
          end
        end
      end
    end

    def parse(url)
      uri = URI.parse(url)
      if uri.query
        path = "#{uri.path}?#{uri.query}"
      else
        path = uri.path
      end
      parse_domains_from_host(uri.host).merge({:path => path})
    end

    def parse_domains_from_host(host)
      parts = host.split(".").reverse
      tld = []
      domain = ""
      subdomains = []
      sub_hash = @tlds
      parts.each_index do |i|
        part = parts[i]

        sub_parts = sub_hash[part]
        sub_hash = sub_parts
        if sub_parts.has_key? "*"
          tld << part
          tld << parts[i+1]
          domain = parts[i+2]
          subdomains = parts.slice(i+3, parts.size)
          break
        elsif sub_parts.empty? || !sub_parts.has_key?(parts[i+1])
          tld << part
          domain = parts[i+1]
          subdomains = parts.slice(i+2, parts.size)
          break
        else
          tld << part
        end
      end
      {:tld => tld.reverse.join("."), :domain => domain, :subdomain => subdomains.reverse.join(".")}
    end
  end
end