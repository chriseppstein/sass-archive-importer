# Sass Archive Importer Plugin

The Sass Archive Importer allows you to import CSS, Sass, and SCSS files
from a zip or jar file without unpacking it.

## Stylesheet Syntax

This importer works with the standard filesystem based import syntax,
allowing you to import from a folder or archive file with the same code.
This allows you to develop against an unpacked version of a library but
also compile the stylesheets against a pre-built archive file (for example,
during a build process).

## Installation

    $ gem install --pre sass-archive-importer

## Use with the Sass command line

    $ sass -r sass-archive-importer -I path/to/archive.zip --watch sass_dir:css_dir

Note: several `-r` options can be given to the sass command line if you
need to require several libraries. Several `-I` options can be passed if
you need to import more than one zip or jar file.

## Use with Compass

Add the following to your compass configuration:

    require 'sass-archive-importer'
    # Note: you can call add_import_path more than once.
    add_import_path File.expand_path("path/to/archive.zip", File.dirname(__FILE__))
    add_import_path File.expand_path("path/to/archive.jar", File.dirname(__FILE__))

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
