# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sass/zip_importer/version"

Gem::Specification.new do |s|
  s.name        = "sass-zip-importer"
  s.version     = Sass::ZipImporter::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Chris Eppstein"]
  s.email       = ["chris@eppsteins.net"]
  s.homepage    = "http://github.com/linkedin/sass-zip-importer"
  s.summary     = "Allows sass, scss, and css files within zip files to be found " +
                  "using Sass @import directives."
  s.description = "Allows sass, scss, and css files within zip files to be found " +
                  "using Sass @import directives."
  s.license     = 'Apache 2.0'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'sass', '>= 3.1'
  s.add_runtime_dependency 'rubyzip', '~> 0.9.9'
end
