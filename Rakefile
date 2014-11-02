require 'rubygems'
require 'rspec/core'
require 'rspec/core/rake_task'
require 'net/http'

RSpec::Core::RakeTask.new(:spec) do |spec|
 spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
 spec.pattern = 'spec/**/*_spec.rb'
 spec.rcov = true
end

task :default => :spec

desc "Update effective_tld_names.dat"
task :update_list do
  File.write("./lib/effective_tld_names.dat", Net::HTTP.get(URI.parse("https://publicsuffix.org/list/effective_tld_names.dat")))
end
