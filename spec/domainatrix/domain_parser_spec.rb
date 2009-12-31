require File.dirname(__FILE__) + '/../spec_helper'

describe "domain parser" do
  before(:all) do
    @domain_parser = Domainatrix::DomainParser.new("#{File.dirname(__FILE__)}/../../lib/effective_tld_names.dat")
  end

  describe "reading the dat file" do
    it "creates a tree of the domain names" do
      @domain_parser.tlds.should be_a Hash
    end

    it "creates the first level of the tree" do
      @domain_parser.tlds.should have_key("com")
    end

    it "creates the first level of the tree even when the first doesn't appear on a line by itself" do
      @domain_parser.tlds.should have_key("uk")
    end

    it "creates lower levels of the tree" do
      @domain_parser.tlds["jp"].should have_key("ac")
      @domain_parser.tlds["jp"]["aichi"].should have_key("*")
    end
  end

  describe "parsing" do
    it "returns a hash of parts" do
      @domain_parser.parse("http://pauldix.net").should be_a Hash
    end

    it "includes the original url" do
      @domain_parser.parse("http://www.pauldix.net")[:url].should == "http://www.pauldix.net"
    end

    it "parses out the path" do
      @domain_parser.parse("http://pauldix.net/foo.html?asdf=foo")[:path].should == "/foo.html?asdf=foo"
      @domain_parser.parse("http://pauldix.net?asdf=foo")[:path].should == "?asdf=foo"
      @domain_parser.parse("http://pauldix.net")[:path].should == ""
    end

    it "parses the tld" do
      @domain_parser.parse("http://pauldix.net")[:tld].should == "net"
      @domain_parser.parse("http://pauldix.co.uk")[:tld].should == "co.uk"
      @domain_parser.parse("http://pauldix.com.kg")[:tld].should == "com.kg"
      @domain_parser.parse("http://pauldix.com.aichi.jp")[:tld].should == "com.aichi.jp"
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