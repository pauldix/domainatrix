$LOAD_PATH.unshift(File.dirname(__FILE__)) unless $LOAD_PATH.include?(File.dirname(__FILE__))

require 'addressable/uri'
require 'domainatrix/domain_parser.rb'
require 'domainatrix/url.rb'

module Domainatrix
  VERSION = "0.0.7"

  def self.parse(url)
    @domain_parser ||= DomainParser.new("#{File.dirname(__FILE__)}/effective_tld_names.dat")
    Url.new(@domain_parser.parse(url))
  end
end