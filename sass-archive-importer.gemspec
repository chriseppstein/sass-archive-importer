# -*- encoding: utf-8 -*-
$:.push File.expand_path("lib", File.dirname(__FILE__))
require "sass_archive_importer/version"

Gem::Specification.new do |s|
  s.name        = "sass-archive-importer"
  s.version     = SassArchiveImporter::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Chris Eppstein"]
  s.email       = ["chris@eppsteins.net"]
  s.homepage    = "http://github.com/linkedin/sass-archive-importer"
  s.summary     = "Allows sass, scss, and css files within zip and jar files to be found " +
                  "using Sass @import directives."
  s.description = "Allows sass, scss, and css files within zip and jar files to be found " +
                  "using Sass @import directives. Also supports loading sass files in " +
                  "JRuby from the java class loader."
  s.license     = 'Apache 2.0'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'sass', '>= 3.1', '< 3.4'
  s.add_runtime_dependency 'rubyzip', '~> 0.9.9'
end
