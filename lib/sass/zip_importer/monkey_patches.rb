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

class Sass::Engine
  alias initialize_without_zip_importer initialize
  
  def initialize(template, options={})
    if options[:load_paths]
      options[:load_paths].map! do |load_path|
        next load_path unless load_path.is_a?(::String) && load_path =~ /\.(zip|jar)$/
        Sass::ZipImporter::Importer.new(load_path)
      end
    end

    initialize_without_zip_importer(template, options)
  end
end

