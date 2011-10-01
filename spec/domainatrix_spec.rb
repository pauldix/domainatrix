require File.dirname(__FILE__) + '/spec_helper'

describe "domainatrix" do
  it "should parse into a url object" do
    Domainatrix.parse("http://pauldix.net").should be_a Domainatrix::Url
  end

  describe :parse do
    it "should canonicalize" do
      Domainatrix.parse("http://pauldix.net").canonical.should == "net.pauldix"
      Domainatrix.parse("http://pauldix.NET").canonical.should == "net.pauldix"
      Domainatrix.parse("http://PAULDIX.net").canonical.should == "net.pauldix"
      Domainatrix.parse("http://PAULDIX.NET").canonical.should == "net.pauldix"
      Domainatrix.parse("HTTP://PAULDIX.NET").canonical.should == "net.pauldix"
      lambda { Domainatrix.parse("") }.should raise_error
      lambda { Domainatrix.parse(nil) }.should raise_error
      Domainatrix.parse("http://pauldix.net/foo.html").canonical.should == "net.pauldix/foo.html"
      Domainatrix.parse("http://pauldix.net/foo.html?asdf=bar").canonical.should == "net.pauldix/foo.html?asdf=bar"
      Domainatrix.parse("http://foo.pauldix.net").canonical.should == "net.pauldix.foo"
      Domainatrix.parse("http://foo.bar.pauldix.net").canonical.should == "net.pauldix.bar.foo"
      Domainatrix.parse("http://pauldix.co.uk").canonical.should == "uk.co.pauldix"
    end
  end
end
