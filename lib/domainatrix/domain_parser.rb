module Domainatrix
  class DomainParser
    include Addressable

    attr_reader :public_suffixes

    def initialize(file_name)
      @public_suffixes = {}
      read_dat_file(file_name)
    end

    def read_dat_file(file_name)
      # If we're in 1.9, make sure we're opening it in UTF-8
      if RUBY_VERSION >= '1.9'
        dat_file = File.open(file_name, "r:UTF-8")
      else
        dat_file = File.open(file_name)
      end

      dat_file.each_line do |line|
        line = line.strip
        add_domain(line) unless (line =~ /\/\//) || line.empty?
      end
    end

    def add_domain(name)
      parts = name.split(".").reverse

      sub_hash = @public_suffixes
      parts.each do |part|
        sub_hash = (sub_hash[part] ||= {})
      end
    end

    def parse(url)
      uri = URI.parse(url)
      path = uri.path
      query = uri.query
      path += "?#{query}" if query

      parse_domains_from_host(uri.host).merge({
        :scheme => uri.scheme,
        :path   => path,
        :url    => url
      })
    end

    def parse_domains_from_host(host)
      public_suffix = parse_public_suffix_from_host(host)
      parts = host.gsub(public_suffix, '').split(".")
      domain = parts.pop
      subdomains = parts.join(".")
      {:public_suffix => public_suffix, :domain => domain, :subdomain => subdomains, :host => host}
    end

    def parse_public_suffix_from_host(host)
      parts = host.split(".").reverse
      sub_hash = @public_suffixes
      public_suffix = []

      parts.each_with_index do |part, i|
        sub_parts = sub_hash[part]
        sub_hash = sub_parts
        public_suffix << part
        next_part = parts[i + 1]
        if sub_parts.has_key? "*"
          public_suffix << next_part
          break
        elsif sub_parts.empty? || !sub_parts.has_key?(next_part)
          break
        end
      end

      public_suffix.reverse.join(".")
    end
  end
end
