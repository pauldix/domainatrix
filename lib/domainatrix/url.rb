module Domainatrix
  class Url
    attr_reader :public_suffix, :domain, :subdomain, :path, :url, :scheme, :host, :port, :parsed_uri

    def initialize(attrs = {})
      @scheme = attrs[:scheme] || ''
      @host = attrs[:host] || ''
      @port = attrs[:port].to_s
      @url = attrs[:url] || ''
      @public_suffix = attrs[:public_suffix] || ''
      @domain = attrs[:domain] || ''
      @subdomain = attrs[:subdomain] || ''
      @path = attrs[:path] || ''
      @localhost = (attrs[:localhost] == true)
      @ip = (attrs[:ip] == true)
      @parsed_uri = attrs[:parsed_uri] || ''
    end

    def canonical(options = {})
      public_suffix_parts = @public_suffix.split(".")
      url = "#{public_suffix_parts.reverse.join(".")}.#{@domain}"
      if @subdomain && !@subdomain.empty?
        subdomain_parts = @subdomain.split(".")
        url << ".#{subdomain_parts.reverse.join(".")}"
      end
      url << @path if @path

      url
    end
    
    def host_with_port
      if !@port.empty?
        "#{@host}:#{@port}"
      else
        host
      end
    end

    def domain_with_port
      if !@port.empty?
        "#{domain_with_public_suffix}:#{@port}"
      else
        domain_with_public_suffix
      end
    end
    
    def domain_with_public_suffix
      [@domain, @public_suffix].compact.reject{|s|s.empty?}.join('.')
    end
    alias domain_with_tld domain_with_public_suffix
    
    def localhost?
      @localhost
    end
    
    def ip?
      @ip
    end
  end
end
