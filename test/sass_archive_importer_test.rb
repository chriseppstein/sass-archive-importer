#!/usr/bin/env ruby

# Copyright 2013 LinkedIn Corp. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

lib_dir = File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))
$: << lib_dir unless $:.include?(lib_dir)
require 'test/unit'
require 'zip/zip'
require 'pathname'
require 'fileutils'
require 'sass'
require 'sass-archive-importer'

class SassArchiveImporterTest < Test::Unit::TestCase
  FIXTURES_DIR = File.expand_path(File.join(File.dirname(__FILE__), "fixtures"))
  # These fixtures are created and kept up to date by the rakefile
  # Run `rake test` to re-create them
  ZIP_FIXTURE = File.join(FIXTURES_DIR, "zipped_files.zip")
  JAR_FIXTURE = File.join(FIXTURES_DIR, "jarred_files.jar")

  def test_can_import_files_from_zip
    css = render_file_from_zip("imports_from_zip.scss")
    assert_match(/\.css-partial/, css)
    assert_match(/\.css-file/, css)
    assert_match(/\.sass-partial/, css)
    assert_match(/\.sass-file/, css)
    assert_match(/\.scss-partial/, css)
    assert_match(/\.scss-file/, css)
    assert_match(/\.nested-class/, css)
    assert_match(/\.deeply-nested/, css)
  end

  def test_can_import_files_from_jar
    css = render_file_from_jar("imports_from_zip.scss")
    assert_match(/\.css-partial/, css)
    assert_match(/\.css-file/, css)
    assert_match(/\.sass-partial/, css)
    assert_match(/\.sass-file/, css)
    assert_match(/\.scss-partial/, css)
    assert_match(/\.scss-file/, css)
    assert_match(/\.nested-class/, css)
    assert_match(/\.deeply-nested/, css)
  end

  def test_can_import_files_from_jar_subfolder
    results = render_file("imports_from_zip_subfolder.scss", "#{JAR_FIXTURE}!nested")
    assert_equal <<CSS, results
.deeply-nested {
  deeply: nested; }

.nested-class {
  nested: yep; }
CSS
  end

  def test_can_import_files_from_zip_subfolder
    results = render_file("imports_from_zip_subfolder.scss", "#{ZIP_FIXTURE}!nested")
    assert_equal <<CSS, results
.deeply-nested {
  deeply: nested; }

.nested-class {
  nested: yep; }
CSS
  end

private
  def render_file(filename, fixture)
    fixtures_dir = File.expand_path("fixtures", File.dirname(__FILE__))
    full_filename = File.expand_path(filename, fixtures_dir)
    syntax = File.extname(full_filename)[1..-1].to_sym
    engine = Sass::Engine.new(File.read(full_filename),
                              :syntax => syntax,
                              :filename => full_filename,
                              :cache => false,
                              :read_cache => false,
                              :load_paths => [fixture])
    engine.render
  end

  def render_file_from_zip(filename)
    render_file(filename, ZIP_FIXTURE)
  end

  def render_file_from_jar(filename)
    render_file(filename, JAR_FIXTURE)
  end
end
