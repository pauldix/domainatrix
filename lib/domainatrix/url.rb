module Domainatrix
  class Url
    attr_reader :tld, :domain, :subdomain, :path

    def initialize(attrs = {})
      @tld = attrs[:tld]
      @domain = attrs[:domain]
      @subdomain = attrs[:subdomain]
      @path = attrs[:path]
    end

    def canonical(options = {})
      tld_parts = @tld.split(".")
      url = "#{tld_parts.reverse.join(".")}.#{@domain}"
      if @subdomain && !@subdomain.empty?
        subdomain_parts = @subdomain.split(".")
        url << ".#{subdomain_parts.reverse.join(".")}"
      end
      url << @path if @path

      url
    end
  end
end
