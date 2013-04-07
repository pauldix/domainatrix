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
        unless (line =~ /\/\//) || line.empty?
          parts = line.split(".").reverse

          sub_hash = @public_suffixes
          parts.each do |part|
            sub_hash = (sub_hash[part] ||= {})
          end
        end
      end
    end

    def parse(url)
      return {} unless url && url.strip != ''
      url = "http://#{url}" unless url[/:\/\//]
      uri = URI.parse(url)
      if uri.query
        path = "#{uri.path}?#{uri.query}"
      else
        path = uri.path
      end
      
      localhost_re = /(\A|\.)localhost\z/
      
      if uri.host =~ localhost_re
        uri_hash = { :public_suffix => '', :domain => 'localhost', :subdomain => uri.host.sub(localhost_re, '') }
      else
        uri_hash = parse_domains_from_host(uri.host || uri.basename)
      end

      uri_hash.merge({
        :scheme => uri.scheme,
        :host   => uri.host,
        :path   => path,
        :url    => url
      })
    end

    def parse_domains_from_host(host)
      return {} unless host
      parts = host.split(".").reverse
      public_suffix = []
      domain = ""
      subdomains = []
      sub_hash = @public_suffixes

      parts.each_with_index do |part, i|
        sub_hash = sub_parts = sub_hash[part] || {}
        if sub_parts.has_key? "*"
          public_suffix << part
          public_suffix << parts[i+1]
          domain = parts[i+2]
          subdomains = parts.slice(i+3, parts.size) || []
          break
        elsif sub_parts.empty? || !sub_parts.has_key?(parts[i+1])
          public_suffix << part
          domain = parts[i+1]
          subdomains = parts.slice(i+2, parts.size) || []
          break
        else
          public_suffix << part
        end
      end

      {:public_suffix => public_suffix.reverse.join("."), :domain => domain, :subdomain => subdomains.reverse.join(".")}
    end
  end
end
