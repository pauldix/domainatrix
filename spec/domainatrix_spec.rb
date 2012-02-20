require File.dirname(__FILE__) + '/spec_helper'

describe "domainatrix" do
  it "should parse into a url object" do
    Domainatrix.parse("http://pauldix.net").should be_a Domainatrix::Url
  end

  it "should canonicalize" do
    Domainatrix.parse("http://pauldix.net").canonical.should == "net.pauldix"
    Domainatrix.parse("http://pauldix.net/foo.html").canonical.should == "net.pauldix/foo.html"
    Domainatrix.parse("http://pauldix.net/foo.html?asdf=bar").canonical.should == "net.pauldix/foo.html?asdf=bar"
    Domainatrix.parse("http://foo.pauldix.net").canonical.should == "net.pauldix.foo"
    Domainatrix.parse("http://foo.bar.pauldix.net").canonical.should == "net.pauldix.bar.foo"
    Domainatrix.parse("http://pauldix.co.uk").canonical.should == "uk.co.pauldix"
  end

  context 'localhost with a port' do
    subject { Domainatrix.parse('localhost:3000') }
    its(:scheme) { should == 'http' }
    its(:host) { should == 'localhost' }
    its(:url) { should == 'http://localhost:3000' }
    its(:public_suffix) { should == '' }
    its(:domain) { should == 'localhost' }
    its(:subdomain) { should == '' }
    its(:path) { should == '' }
    its(:domain_with_tld) { should == 'localhost' }
  end

  context 'without a scheme' do
    subject { Domainatrix.parse('www.pauldix.net') }
    its(:scheme) { should == 'http' }
    its(:host) { should == 'www.pauldix.net' }
    its(:url) { should == 'http://www.pauldix.net' }
    its(:public_suffix) { should == 'net' }
    its(:domain) { should == 'pauldix' }
    its(:subdomain) { should == 'www' }
    its(:path) { should == '' }
    its(:domain_with_tld) { should == 'pauldix.net' }
  end

  context 'with a blank url' do
    subject { Domainatrix.parse(nil) }
    its(:scheme) { should == '' }
    its(:host) { should == '' }
    its(:url) { should == '' }
    its(:public_suffix) { should == '' }
    its(:domain) { should == '' }
    its(:subdomain) { should == '' }
    its(:path) { should == '' }
    its(:domain_with_tld) { should == '' }
  end

end
