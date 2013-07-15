# Sass Zip Importer Plugin

The Sass Zip Importer allows you to import CSS, Sass, and SCSS files
from a zip file without unpacking it.

## Stylesheet Syntax

This importer works with the standard filesystem based import syntax,
allowing you to import from a folder or zip file with the same code.
This allows you to develop against an unpacked version of a library but
also compile the stylesheets against a pre-built zip file (for example,
during a build process).

## Installation

    $ gem install --pre sass-zip-importer

## Use with the Sass command line

    $ sass -r sass-zip-importer -I path/to/file.zip --watch sass_dir:css_dir

Note: several -r options can be given to the sass command line if you
need to require several libraries.

## Use with Compass

Add the following to your compass configuration:

    require 'sass-zip-importer'
    # Note: you can call add_import_path more than once.
    add_import_path "#{File.dirname(__FILE__)}/path/to/file.zip"

# Legal Stuff

Copyright 2013 LinkedIn Corp. All rights reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
