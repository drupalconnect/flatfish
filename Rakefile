require 'rake'
require 'rake/testtask'

task :default => [:test_units]

desc "Run basic tests"
Rake::TestTask.new("test_units") do |t|
  t.pattern = 'test/*_test.rb'
  t.verbose = false 
  t.warning = true
end
