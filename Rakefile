require 'rake'
require 'rake/testtask'

task :default => [:test_units]

desc "Run basic tests"
Rake::TestTask.new("test_units") do |t|
  t.pattern = 'test/*_test.rb'
  t.verbose = false 
  t.warning = true
end

RUBY='1.9.3'

desc "Build gem"
task :build_gem do
  system "rvm #{RUBY} do gem build flatfish.gemspec"
end

desc "Install gem"
task :install_gem => :build_gem do
  system "sudo rvm #{RUBY} do gem install flatfish-*.gem"
end
