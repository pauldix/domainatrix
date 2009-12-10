require File.dirname(__FILE__) + '/../spec_helper'

describe "domain parser" do
  before(:all) do
    @domain_parser = Domainatrix::DomainParser.new("#{File.dirname(__FILE__)}/../../lib/effective_tld_names.dat")
  end

  describe "reading the dat file" do
    it "create a trie of the domain names" do
      @domain_parser.tlds.should be_a Hash
    end

    it "should have the first level of the tree" do
      @domain_parser.tlds.should have_key("com")
    end

    it "should have the first level of the tree even when the first doesn't appear on a line by itself" do
      @domain_parser.tlds.should have_key("uk")
    end

    it "should have lower levels of the tree" do
      @domain_parser.tlds["jp"].should have_key("ac")
    end
  end
end