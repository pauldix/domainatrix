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

  it "has the port" do
    Domainatrix::Url.new(:port => 8000).port.should == 8000
  end

  def should_canonicalize_url_for_port(given_port = nil, resulting_port = nil)
    Domainatrix::Url.new(:domain => "pauldix", :public_suffix => "net", :port => given_port).canonical.should == "net.pauldix#{resulting_port}"
    Domainatrix::Url.new(:subdomain => "foo", :domain => "pauldix", :public_suffix => "net", :port => given_port).canonical.should == "net.pauldix.foo#{resulting_port}"
    Domainatrix::Url.new(:subdomain => "foo.bar", :domain => "pauldix", :public_suffix => "net", :port => given_port).canonical.should == "net.pauldix.bar.foo#{resulting_port}"
    Domainatrix::Url.new(:domain => "pauldix", :public_suffix => "co.uk", :port => given_port).canonical.should == "uk.co.pauldix#{resulting_port}"
    Domainatrix::Url.new(:subdomain => "foo", :domain => "pauldix", :public_suffix => "co.uk", :port => given_port).canonical.should == "uk.co.pauldix.foo#{resulting_port}"
    Domainatrix::Url.new(:subdomain => "foo.bar", :domain => "pauldix", :public_suffix => "co.uk", :port => given_port).canonical.should == "uk.co.pauldix.bar.foo#{resulting_port}"
    Domainatrix::Url.new(:subdomain => "", :domain => "pauldix", :public_suffix => "co.uk", :port => given_port).canonical.should == "uk.co.pauldix#{resulting_port}"
  end

  def should_canonicalize_url_without_port
    should_canonicalize_url_for_port
  end

  it "canonicalizes the url" do
    should_canonicalize_url_without_port
    should_canonicalize_url_for_port 80
    should_canonicalize_url_for_port 8000, ":8000"
  end

  def should_canonicalize_url_with_path_for_port(given_port = nil, resulting_port = nil)
    Domainatrix::Url.new(:subdomain => "foo", :domain => "pauldix", :public_suffix => "net", :path => "/hello", :port => given_port).canonical.should == "net.pauldix.foo#{resulting_port}/hello"
  end

  def should_canonicalize_url_with_path_without_port
    should_canonicalize_url_with_path_for_port
  end

  it "canonicalizes the url with the path" do
    should_canonicalize_url_with_path_without_port
    should_canonicalize_url_with_path_for_port 80
    should_canonicalize_url_with_path_for_port 8000, ":8000"
  end

  def should_canonicalize_url_without_path_for_port(given_port = nil, resulting_port = nil)
    Domainatrix::Url.new(:subdomain => "foo", :domain => "pauldix", :public_suffix => "net", :port => given_port).canonical(:include_path => false).should == "net.pauldix.foo#{resulting_port}"
  end

  def should_canonicalize_url_without_path_without_port
    should_canonicalize_url_with_path_for_port
  end

  it "canonicalizes the url without the path" do
    should_canonicalize_url_without_path_without_port
    should_canonicalize_url_without_path_for_port 80
    should_canonicalize_url_without_path_for_port 8000, ":8000"
  end

  def should_combine_domain_with_public_suffix_for_port(given_port = nil)
    Domainatrix::Url.new(:domain => "pauldix", :public_suffix => "net", :port => given_port).domain_with_public_suffix.should == "pauldix.net"
    Domainatrix::Url.new(:domain => "foo", :public_suffix => "co.uk", :port => given_port).domain_with_public_suffix.should == "foo.co.uk"
    Domainatrix::Url.new(:subdomain => "baz", :domain => "bar", :public_suffix => "com", :port => given_port).domain_with_public_suffix.should == "bar.com"
  end

  def should_combine_domain_with_public_suffix_without_port
    should_combine_domain_with_public_suffix_for_port
  end

  it "combines the domain with the public_suffix" do
    should_combine_domain_with_public_suffix_without_port
    should_combine_domain_with_public_suffix_for_port 80
    should_combine_domain_with_public_suffix_for_port 8000
  end

  def should_combine_domain_with_public_suffix_as_an_alias_for_port(given_port = nil)
    Domainatrix::Url.new(:domain => "pauldix", :public_suffix => "net", :port => given_port).domain_with_tld.should == "pauldix.net"
    Domainatrix::Url.new(:domain => "foo", :public_suffix => "co.uk", :port => given_port).domain_with_tld.should == "foo.co.uk"
    Domainatrix::Url.new(:subdomain => "baz", :domain => "bar", :public_suffix => "com", :port => given_port).domain_with_tld.should == "bar.com"
  end

  def should_combine_domain_with_public_suffix_as_an_alias_without_port
    should_combine_domain_with_public_suffix_as_an_alias_for_port
  end

  it "combines the domain with the public_suffix as an alias" do
    should_combine_domain_with_public_suffix_as_an_alias_without_port
    should_combine_domain_with_public_suffix_as_an_alias_for_port 80
    should_combine_domain_with_public_suffix_as_an_alias_for_port 8000
  end
end
