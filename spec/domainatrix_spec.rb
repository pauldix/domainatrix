require File.dirname(__FILE__) + '/spec_helper'

describe "domainatrix" do
  it "should parse into a url object" do
    expect(Domainatrix.parse("http://pauldix.net")).to be_a Domainatrix::Url
  end

  it "should canonicalize" do
    expect(Domainatrix.parse("http://pauldix.net").canonical).to eq("net.pauldix")
    expect(Domainatrix.parse("http://pauldix.net/foo.html").canonical).to eq("net.pauldix/foo.html")
    expect(Domainatrix.parse("http://pauldix.net/foo.html?asdf=bar").canonical).to eq("net.pauldix/foo.html?asdf=bar")
    expect(Domainatrix.parse("http://foo.pauldix.net").canonical).to eq("net.pauldix.foo")
    expect(Domainatrix.parse("http://foo.bar.pauldix.net").canonical).to eq("net.pauldix.bar.foo")
    expect(Domainatrix.parse("http://pauldix.co.uk").canonical).to eq("uk.co.pauldix")
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
