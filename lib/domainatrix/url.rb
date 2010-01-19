module Domainatrix
  class Url
    attr_reader :public_suffix, :domain, :subdomain, :path, :url, :scheme, :host

    def initialize(attrs = {})
      @scheme = attrs[:scheme]
      @host = attrs[:host]
      @url = attrs[:url]
      @public_suffix = attrs[:public_suffix]
      @domain = attrs[:domain]
      @subdomain = attrs[:subdomain]
      @path = attrs[:path]
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
  end
end
