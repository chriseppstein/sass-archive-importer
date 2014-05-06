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

require 'rubygems'
require 'sass'
require 'sass/engine'
require 'sass/importers'
require 'java'

java_package "org.sass.archive_importer"

class ClassLoaderImporter < Sass::Importers::Base
  include Java

  attr_reader :sub_folder

  def extensions
    {
      ".scss" => :scss,
      ".css" => :scss,
      ".sass" => :sass
    }
  end

  class Entry < Struct.new(:name, :stream, :url)
    def read
      return @result if @result
      reader = java.io.BufferedReader.new(java.io.InputStreamReader.new(stream, "utf8"));
      @result = ""
      while (line = reader.read_line)
        @result << line
        @result << "\n"
      end
      @result
    end

    def time
      Time.at(url.open_connection.get_last_modified / 1000)
    end
  end

  def initialize(sub_folder = nil)
    require 'pathname'
    sub_folder = sub_folder[1..-1] if sub_folder && sub_folder.start_with?("/")
    @sub_folder = sub_folder
  end

  # Enable watching of css files in Sass 3.3+
  def watched_directories
    []
  end

  # Enable watching of css files in Sass 3.3+
  java_signature 'boolean isWatchedFile(String)'
  def watched_file?(file)
    false
  end

  def find_relative(name, base, options)
    name = normalize_name(name)
    base = normalize_name(base)
    if entry = entry_for(name, base)
      engine(entry, options)
    end
  end


  def find(name, options)
    name = normalize_name(name)
    if entry = entry_for(name)
      engine(entry, options)
    end
  end

  def engine(entry, options)
    options[:syntax] = extensions.fetch(File.extname(entry.name), :scss)
    options[:filename] = full_filename(entry)
    options[:importer] = self
    content = entry.read
    Sass::Engine.new(content, options)
  end


  def mtime(name, options)
    name = normalize_name(name)
    if entry = find_entry(name)
      entry.time
    else
      nil
    end
  end

  def key(name, options)
    [to_s, normalize_name(name)]
  end

  java_signature 'boolean isEql(IRubyObject)'
  def eql?(other)
    other.class == self.class &&
      other.sub_folder == self.sub_folder
  end

  def to_s
    @string_representation ||= "<ClassLoaderImporter#{'/' if sub_folder}#{sub_folder}>"
  end

  protected

  def normalize_name(name)
    return unless name
    name = name[to_s.length..-1] if name.start_with?(to_s)
    name = name[1..-1] if name.start_with?("/")
    name = name[(sub_folder.length + 1)..-1] if sub_folder && name.start_with?("#{sub_folder}/")
    name
  end


  def full_filename(entry)
    "#{to_s}/#{normalize_name(entry.name)}"
  end

  def entry_for(name, base = nil)
    possible_names(name, base).each do |n|
      n = "#{sub_folder}/#{n}" if sub_folder
      if entry = find_entry(n)
        return entry
      end
    end
    nil
  end

  def find_entry(name)
    stream = self.to_java.java_class.getResourceAsStream("/"+name)
    return unless stream
    url = self.to_java.java_class.getResource("/"+name)
    Entry.new(name, stream, url)
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
end
