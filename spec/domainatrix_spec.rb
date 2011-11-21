# coding: utf-8

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

  it "should canonicalize extended utf-8 tlds" do
    Domainatrix.parse("http://pauldix.臺灣").canonical.should == "臺灣.pauldix"
    Domainatrix.parse("http://pauldix.السعوديه").canonical.should == "السعوديه.pauldix"
  end

  it "should not canonicalize invalid domain names" do
    Domainatrix.parse("http://hello.world").canonical.should be_nil
    Domainatrix.parse("http://helloworld").canonical.should be_nil
  end

  it "should accept custom tlds" do
    Domainatrix.recognize_tld("foo").should == ['foo']
    Domainatrix.parse("http://pauldix.foo").should be_a Domainatrix::Url
    Domainatrix.parse("http://pauldix.foo").canonical.should == "foo.pauldix"
  end
end
