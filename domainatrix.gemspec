# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{domainatrix}
  s.version = "0.0.10"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Paul Dix", "Brian John"]
  s.date = %q{2012-09-22}
  s.email = ["paul@pauldix.net", "brian@brianjohn.com"]
  s.files = [
    "lib/domainatrix.rb",
    "lib/effective_tld_names.dat",
    "lib/domainatrix/domain_parser.rb",
    "lib/domainatrix/url.rb",
    "CHANGELOG.md",
    "README.textile",
    "spec/spec.opts",
    "spec/spec_helper.rb",
    "spec/domainatrix_spec.rb",
    "spec/domainatrix/domain_parser_spec.rb",
    "spec/domainatrix/url_spec.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/pauldix/domainatrix}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{A cruel mistress that uses the public suffix domain list to dominate URLs by canonicalizing, finding the public suffix, and breaking them into their domain parts.}
  s.add_dependency("addressable")
  s.add_development_dependency("rspec")

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
