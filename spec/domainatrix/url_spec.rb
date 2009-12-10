require File.dirname(__FILE__) + '/../spec_helper'

describe "url" do
  it "has the tld" do
    Domainatrix::Url.new(:tld => "net").tld.should == "net"
  end

  it "has the domain" do
    Domainatrix::Url.new(:domain => "pauldix").domain.should == "pauldix"
  end

  it "has the subdomain" do
    Domainatrix::Url.new(:subdomain => "foo").subdomain.should == "foo"
  end

  it "has the path" do
    Domainatrix::Url.new(:path => "/asdf.html").path.should == "/asdf.html"
  end

  it "canonicalizes the url without www" do
    Domainatrix::Url.new(:subdomain => "www", :domain => "pauldix", :tld => "net").canonical.should == "net.pauldix"
    Domainatrix::Url.new(:subdomain => "www.foo", :domain => "pauldix", :tld => "net").canonical.should == "net.pauldix.foo"
  end

  it "canonicalizes the url with www" do
    Domainatrix::Url.new(:subdomain => "www", :domain => "pauldix", :tld => "net").canonical(:include_www => true).should == "net.pauldix.www"
  end

  it "canonicalizes the url with the path" do
    Domainatrix::Url.new(:subdomain => "foo", :domain => "pauldix", :tld => "net", :path => "/hello").canonical.should == "net.pauldix.foo/hello"
  end

  it "canonicalizes the url without the path" do
    Domainatrix::Url.new(:subdomain => "foo", :domain => "pauldix", :tld => "net").canonical(:include_path => false).should == "net.pauldix.foo"
  end
end
