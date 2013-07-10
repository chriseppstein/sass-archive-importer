#!/usr/bin/env ruby
lib_dir = File.expand_path(File.join(File.dirname(__FILE__), "..", "lib"))
$: << lib_dir unless $:.include?(lib_dir)
require 'test/unit'
require 'zip/zip'
require 'pathname'
require 'fileutils'
require 'sass'
require 'sass-zip-importer'

class SassZipImporterTest < Test::Unit::TestCase
  ZIP_FIXTURE_DIR = File.expand_path(File.join(File.dirname(__FILE__), "fixtures", "zipped_files"))
  ZIP_FIXTURE = File.expand_path(File.join(File.dirname(__FILE__), "fixtures", "zipped_files.zip"))

  def setup
    unless $zip_created
      $zip_created = true
      zip_path = Pathname.new(ZIP_FIXTURE_DIR)
      FileUtils.rm_f(ZIP_FIXTURE)
      Zip::ZipOutputStream.open(ZIP_FIXTURE) do |io|
        Dir.glob("#{ZIP_FIXTURE_DIR}/**/*.*").each do |file|
          filename = Pathname.new(file).relative_path_from(zip_path)
          io.put_next_entry(filename.to_s)
          io.write File.read(file)
        end
      end
    end
  end

  def test_can_import_css_files_files
    css = render_file("imports_from_zip.scss")
    assert_match(/\.css-partial/, css)
    assert_match(/\.css-file/, css)
    assert_match(/\.sass-partial/, css)
    assert_match(/\.sass-file/, css)
    assert_match(/\.scss-partial/, css)
    assert_match(/\.scss-file/, css)
    assert_match(/\.nested-class/, css)
    assert_match(/\.deeply-nested/, css)
  end

private
  def render_file(filename)
    fixtures_dir = File.expand_path("fixtures", File.dirname(__FILE__))
    full_filename = File.expand_path(filename, fixtures_dir)
    syntax = File.extname(full_filename)[1..-1].to_sym
    engine = Sass::Engine.new(File.read(full_filename),
                              :syntax => syntax,
                              :filename => full_filename,
                              :cache => false,
                              :read_cache => false,
                              :load_paths => [ZIP_FIXTURE])
    engine.render
  end
end
