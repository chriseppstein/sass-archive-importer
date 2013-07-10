require 'sass'

class Sass::Engine
  alias initialize_without_zip_importer initialize
  
  def initialize(template, options={})
    if options[:load_paths]
      options[:load_paths].map! do |load_path|
        next load_path unless load_path.is_a?(::String) && load_path =~ /\.zip$/
        Sass::ZipImporter::Importer.new(load_path)
      end
    end

    initialize_without_zip_importer(template, options)
  end
end

