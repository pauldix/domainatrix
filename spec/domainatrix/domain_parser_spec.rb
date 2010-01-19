require File.dirname(__FILE__) + '/../spec_helper'

describe "domain parser" do
  before(:all) do
    @domain_parser = Domainatrix::DomainParser.new("#{File.dirname(__FILE__)}/../../lib/effective_tld_names.dat")
  end

  describe "reading the dat file" do
    it "creates a tree of the domain names" do
      @domain_parser.public_suffixes.should be_a Hash
    end

    it "creates the first level of the tree" do
      @domain_parser.public_suffixes.should have_key("com")
    end

    it "creates the first level of the tree even when the first doesn't appear on a line by itself" do
      @domain_parser.public_suffixes.should have_key("uk")
    end

    it "creates lower levels of the tree" do
      @domain_parser.public_suffixes["jp"].should have_key("ac")
      @domain_parser.public_suffixes["jp"]["aichi"].should have_key("*")
    end
  end

  describe "parsing" do
    it "returns a hash of parts" do
      @domain_parser.parse("http://pauldix.net").should be_a Hash
    end

    it "includes the original url" do
      @domain_parser.parse("http://www.pauldix.net")[:url].should == "http://www.pauldix.net"
    end

    it "includes the scheme" do
      @domain_parser.parse("http://www.pauldix.net")[:scheme].should == "http"
    end
    
    it "includes the full host" do
      @domain_parser.parse("http://www.pauldix.net")[:host].should == "www.pauldix.net"      
    end
    
    it "parses out the path" do
      @domain_parser.parse("http://pauldix.net/foo.html?asdf=foo")[:path].should == "/foo.html?asdf=foo"
      @domain_parser.parse("http://pauldix.net?asdf=foo")[:path].should == "?asdf=foo"
      @domain_parser.parse("http://pauldix.net")[:path].should == ""
    end

    it "parses the tld" do
      @domain_parser.parse("http://pauldix.net")[:public_suffix].should == "net"
      @domain_parser.parse("http://pauldix.co.uk")[:public_suffix].should == "co.uk"
      @domain_parser.parse("http://pauldix.com.kg")[:public_suffix].should == "com.kg"
      @domain_parser.parse("http://pauldix.com.aichi.jp")[:public_suffix].should == "com.aichi.jp"
    end

    it "should have the domain" do
      @domain_parser.parse("http://pauldix.net")[:domain].should == "pauldix"
      @domain_parser.parse("http://foo.pauldix.net")[:domain].should == "pauldix"
      @domain_parser.parse("http://pauldix.co.uk")[:domain].should == "pauldix"
      @domain_parser.parse("http://foo.pauldix.co.uk")[:domain].should == "pauldix"
      @domain_parser.parse("http://pauldix.com.kg")[:domain].should == "pauldix"
      @domain_parser.parse("http://pauldix.com.aichi.jp")[:domain].should == "pauldix"
    end

    it "should have subdomains" do
      @domain_parser.parse("http://foo.pauldix.net")[:subdomain].should == "foo"
      @domain_parser.parse("http://bar.foo.pauldix.co.uk")[:subdomain].should == "bar.foo"
    end
  end
end