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
      url = "#{@tld}.#{@domain}"
      if @subdomain
        if options[:include_www]
          url << ".#{@subdomain}"
        else
          sub_without_www = @subdomain.gsub(/^www/, "")
          url << (sub_without_www.start_with?(".") ? sub_without_www : ".#{sub_without_www}") unless sub_without_www.empty?
        end
      end
      url << @path if @path

      url
    end
  end
end
