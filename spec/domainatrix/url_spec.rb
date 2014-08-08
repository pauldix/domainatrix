require File.dirname(__FILE__) + '/../spec_helper'

describe "url" do
  it "has the original url" do
    expect(Domainatrix::Url.new(:url => "http://pauldix.net").url).to eq("http://pauldix.net")
  end

  it "has the public_suffix" do
    expect(Domainatrix::Url.new(:public_suffix => "net").public_suffix).to eq("net")
  end

  it "has the domain" do
    expect(Domainatrix::Url.new(:domain => "pauldix").domain).to eq("pauldix")
  end

  it "has the subdomain" do
    expect(Domainatrix::Url.new(:subdomain => "foo").subdomain).to eq("foo")
  end

  it "has the path" do
    expect(Domainatrix::Url.new(:path => "/asdf.html").path).to eq("/asdf.html")
  end

  it "canonicalizes the url" do
    expect(Domainatrix::Url.new(:domain => "pauldix", :public_suffix => "net").canonical).to eq("net.pauldix")
    expect(Domainatrix::Url.new(:subdomain => "foo", :domain => "pauldix", :public_suffix => "net").canonical).to eq("net.pauldix.foo")
    expect(Domainatrix::Url.new(:subdomain => "foo.bar", :domain => "pauldix", :public_suffix => "net").canonical).to eq("net.pauldix.bar.foo")
    expect(Domainatrix::Url.new(:domain => "pauldix", :public_suffix => "co.uk").canonical).to eq("uk.co.pauldix")
    expect(Domainatrix::Url.new(:subdomain => "foo", :domain => "pauldix", :public_suffix => "co.uk").canonical).to eq("uk.co.pauldix.foo")
    expect(Domainatrix::Url.new(:subdomain => "foo.bar", :domain => "pauldix", :public_suffix => "co.uk").canonical).to eq("uk.co.pauldix.bar.foo")
    expect(Domainatrix::Url.new(:subdomain => "", :domain => "pauldix", :public_suffix => "co.uk").canonical).to eq("uk.co.pauldix")
  end

  it "canonicalizes the url with the path" do
    expect(Domainatrix::Url.new(:subdomain => "foo", :domain => "pauldix", :public_suffix => "net", :path => "/hello").canonical).to eq("net.pauldix.foo/hello")
  end

  it "canonicalizes the url without the path" do
    expect(Domainatrix::Url.new(:subdomain => "foo", :domain => "pauldix", :public_suffix => "net").canonical(:include_path => false)).to eq("net.pauldix.foo")
  end

  it "combines the domain with the public_suffix" do
    expect(Domainatrix::Url.new(:domain => "pauldix", :public_suffix => "net").domain_with_public_suffix).to eq("pauldix.net")
    expect(Domainatrix::Url.new(:domain => "foo", :public_suffix => "co.uk" ).domain_with_public_suffix).to eq("foo.co.uk")
    expect(Domainatrix::Url.new(:subdomain => "baz", :domain => "bar", :public_suffix => "com").domain_with_public_suffix).to eq("bar.com")
  end
  
  it "combines the domain with the public_suffix as an alias" do
    expect(Domainatrix::Url.new(:domain => "pauldix", :public_suffix => "net").domain_with_tld).to eq("pauldix.net")
    expect(Domainatrix::Url.new(:domain => "foo", :public_suffix => "co.uk" ).domain_with_tld).to eq("foo.co.uk")
    expect(Domainatrix::Url.new(:subdomain => "baz", :domain => "bar", :public_suffix => "com").domain_with_tld).to eq("bar.com")
  end

end
