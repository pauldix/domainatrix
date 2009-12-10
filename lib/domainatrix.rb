$LOAD_PATH.unshift(File.dirname(__FILE__)) unless $LOAD_PATH.include?(File.dirname(__FILE__))

require 'domainatrix/domain_parser.rb'

module Domainatrix
  VERSION = "0.0.1"
end