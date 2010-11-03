# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "beaconpush/version"

Gem::Specification.new do |s|
  s.name        = "beaconpush"
  s.version     = Beaconpush::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jakub Kuźma"]
  s.email       = ["qoobaa@gmail.com"]
  s.homepage    = "http://rubygems.org/gems/beaconpush"
  s.summary     = %q{Gem for adding Beacon support into your application}
  s.description = %q{Gem for adding Beacon support into your application}

  s.rubyforge_project = "beaconpush"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
