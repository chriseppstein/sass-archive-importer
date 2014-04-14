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

require 'sass'

class SassArchiveImporter::Importer < Sass::Importers::Base

  attr_reader :archive_file
  attr_reader :sub_folder
  
  def extensions
    {
      ".scss" => :scss,
      ".css" => :scss,
      ".sass" => :sass
    }
  end

  def initialize(archive_file, sub_folder = nil)
    require 'zip/zip'
    require 'pathname'
    @archive_file = File.expand_path(archive_file)
    @sub_folder = sub_folder
  end

  # Enable watching of css files in Sass 3.3+
  def watched_directories
    [File.dirname(archive_file)]
  end

  # Enable watching of css files in Sass 3.3+
  def watched_file?(file)
    archive_file == file
  end

  def find_relative(name, base, options)
    base = base.split("!", 2).last
    if entry = entry_for(name, base)
      engine(entry, options)
    end
  end


  def find(name, options)
    if entry = entry_for(name)
      engine(entry, options)
    end
  end

  def engine(entry, options)
    options[:syntax] = extensions.fetch(File.extname(entry.name), :scss)
    options[:filename] = full_filename(entry)
    options[:importer] = self
    Sass::Engine.new(zip.read(entry), options)
  end
  

  def mtime(name, options)
    if entry = entry_for(name)
      entry.time
    end
    nil
  end

  def key(name, options)
    name.split("!", 2)
  end

  def to_s
    archive_file
  end

  def eql?(other)
    other.class == self.class &&
      other.archive_file == self.archive_file
      other.sub_folder == self.sub_folder
  end

  protected

  def full_filename(entry)
    "#{archive_file}!#{entry.name}"
  end

  def entry_for(name, base = nil)
    possible_names(name, base).each do |n|
      n = "#{sub_folder}/#{n}" if sub_folder
      if entry = zip.find_entry(n)
        return entry
      end
    end
    nil
  end

  def possible_names(name, base = nil)
    if base
      absolute_root = Pathname.new("/")
      base_path = Pathname.new(base)
      path = Pathname.new(name)
      begin
        name = absolute_root.join(base_path).dirname.join(path).relative_path_from(absolute_root).to_s
      rescue
        # couldn't create a relative path, so we'll just assume it's absolute or for a different importer.
        return []
      end
    end
    d, b = File.split(name)
    names = if b.start_with?("_")
              [name]
            else
              [name, d == "." ? "_#{b}" : "#{d}/_#{b}"]
            end

    names.map do |n|
      if (ext = File.extname(n)).size > 0 && extensions.keys.include?(ext)
        n
      else
        extensions.keys.map{|k| "#{n}#{k}" }
      end
    end.flatten
  end

  def zip
    @zip ||= open_zip_file!
  end

  def open_zip_file!
    z = Zip::ZipFile.open(archive_file)
    at_exit { z.close }
    z
  end

end
