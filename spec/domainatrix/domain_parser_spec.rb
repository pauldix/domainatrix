require File.dirname(__FILE__) + '/../spec_helper'

describe "domain parser" do
  before(:all) do
    @domain_parser = Domainatrix::DomainParser.new("#{File.dirname(__FILE__)}/../../lib/effective_tld_names.dat")
  end

  describe "reading the dat file" do
    it "creates a tree of the domain names" do
      expect(@domain_parser.public_suffixes).to be_a Hash
    end

    it "creates the first level of the tree" do
      expect(@domain_parser.public_suffixes).to have_key("com")
    end

    it "creates the first level of the tree even when the first doesn't appear on a line by itself" do
      expect(@domain_parser.public_suffixes).to have_key("uk")
    end

    it "creates lower levels of the tree" do
      expect(@domain_parser.public_suffixes["jp"]).to have_key("ac")
      expect(@domain_parser.public_suffixes["jp"]["kawasaki"]).to have_key("*")
    end
  end

  describe "parsing" do
    it "returns a hash of parts" do
      expect(@domain_parser.parse("http://pauldix.net")).to be_a Hash
    end

    it "includes the original url" do
      expect(@domain_parser.parse("http://www.pauldix.net")[:url]).to eq("http://www.pauldix.net")
    end

    it "includes the scheme" do
      expect(@domain_parser.parse("http://www.pauldix.net")[:scheme]).to eq("http")
    end
    
    it "includes the full host" do
      expect(@domain_parser.parse("http://www.pauldix.net")[:host]).to eq("www.pauldix.net")      
    end
    
    it "parses out the path" do
      expect(@domain_parser.parse("http://pauldix.net/foo.html?asdf=foo")[:path]).to eq("/foo.html?asdf=foo")
      expect(@domain_parser.parse("http://pauldix.net?asdf=foo")[:path]).to eq("?asdf=foo")
      expect(@domain_parser.parse("http://pauldix.net")[:path]).to eq("")
    end

    it "parses the tld" do
      expect(@domain_parser.parse("http://pauldix.net")[:public_suffix]).to eq("net")
      expect(@domain_parser.parse("http://pauldix.co.uk")[:public_suffix]).to eq("co.uk")
      expect(@domain_parser.parse("http://pauldix.com.kg")[:public_suffix]).to eq("com.kg")
      expect(@domain_parser.parse("http://pauldix.com.kawasaki.jp")[:public_suffix]).to eq("com.kawasaki.jp")
    end

    it "should have the domain" do
      expect(@domain_parser.parse("http://pauldix.net")[:domain]).to eq("pauldix")
      expect(@domain_parser.parse("http://foo.pauldix.net")[:domain]).to eq("pauldix")
      expect(@domain_parser.parse("http://pauldix.co.uk")[:domain]).to eq("pauldix")
      expect(@domain_parser.parse("http://foo.pauldix.co.uk")[:domain]).to eq("pauldix")
      expect(@domain_parser.parse("http://pauldix.com.kg")[:domain]).to eq("pauldix")
      expect(@domain_parser.parse("http://pauldix.com.kawasaki.jp")[:domain]).to eq("pauldix")
    end

    it "should have subdomains" do
      expect(@domain_parser.parse("http://foo.pauldix.net")[:subdomain]).to eq("foo")
      expect(@domain_parser.parse("http://bar.foo.pauldix.co.uk")[:subdomain]).to eq("bar.foo")
    end
  end
end
