# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "flatfish"

Gem::Specification.new do |s|
  s.name        = 'flatfish'
  s.version     = Flatfish::VERSION
  s.date        = '2011-12-28'
  s.summary     = "Scrape web pages!"
  s.description = "flatfish accepts a CSV of URLS with CSS selectors prepping them for insert into drupal"
  s.authors     = ["Tim Loudon", "Mike Crittenden"]
  s.email       = 'timl@drupalconnect.com'
  s.homepage    = 'https://github.com/drupalstaffing/flatfish'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
