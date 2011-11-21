require File.dirname(__FILE__) + '/../spec_helper'

describe "url" do
  it "has the original url" do
    Domainatrix::Url.new(:url => "http://pauldix.net").url.should == "http://pauldix.net"
  end

  it "has the public_suffix" do
    Domainatrix::Url.new(:public_suffix => "net").public_suffix.should == "net"
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

  it "canonicalizes the url" do
    Domainatrix::Url.new(:domain => "pauldix", :public_suffix => "net").canonical.should == "net.pauldix"
    Domainatrix::Url.new(:subdomain => "foo", :domain => "pauldix", :public_suffix => "net").canonical.should == "net.pauldix.foo"
    Domainatrix::Url.new(:subdomain => "foo.bar", :domain => "pauldix", :public_suffix => "net").canonical.should == "net.pauldix.bar.foo"
    Domainatrix::Url.new(:domain => "pauldix", :public_suffix => "co.uk").canonical.should == "uk.co.pauldix"
    Domainatrix::Url.new(:subdomain => "foo", :domain => "pauldix", :public_suffix => "co.uk").canonical.should == "uk.co.pauldix.foo"
    Domainatrix::Url.new(:subdomain => "foo.bar", :domain => "pauldix", :public_suffix => "co.uk").canonical.should == "uk.co.pauldix.bar.foo"
    Domainatrix::Url.new(:subdomain => "", :domain => "pauldix", :public_suffix => "co.uk").canonical.should == "uk.co.pauldix"
  end

  it "canonicalizes the url with the path" do
    Domainatrix::Url.new(:subdomain => "foo", :domain => "pauldix", :public_suffix => "net", :path => "/hello").canonical.should == "net.pauldix.foo/hello"
  end

  it "canonicalizes the url without the path" do
    Domainatrix::Url.new(:subdomain => "foo", :domain => "pauldix", :public_suffix => "net").canonical(:include_path => false).should == "net.pauldix.foo"
  end

  it "combines the domain with the public_suffix" do
    Domainatrix::Url.new(:domain => "pauldix", :public_suffix => "net").domain_with_public_suffix.should == "pauldix.net"
    Domainatrix::Url.new(:domain => "foo", :public_suffix => "co.uk" ).domain_with_public_suffix.should == "foo.co.uk"
    Domainatrix::Url.new(:subdomain => "baz", :domain => "bar", :public_suffix => "com").domain_with_public_suffix.should == "bar.com"
  end

  it "combines the domain with the public_suffix as an alias" do
    Domainatrix::Url.new(:domain => "pauldix", :public_suffix => "net").domain_with_tld.should == "pauldix.net"
    Domainatrix::Url.new(:domain => "foo", :public_suffix => "co.uk" ).domain_with_tld.should == "foo.co.uk"
    Domainatrix::Url.new(:subdomain => "baz", :domain => "bar", :public_suffix => "com").domain_with_tld.should == "bar.com"
  end

  describe :valid? do
    it "should return false without a public suffix" do
      Domainatrix.parse("http://www.test.com").should be_valid
      Domainatrix.parse("htpp://www.test.this_is_not_a_public_suffix").should_not be_valid
    end
  end
end
