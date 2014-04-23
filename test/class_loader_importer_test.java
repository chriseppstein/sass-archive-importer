//import org.sass.archive_importer.ClassLoaderImporter;
import org.jruby.Ruby;

class ClassLoaderImporterTest {
  public void testClassLoaderImporter() {
    final Ruby runtime = Ruby.newInstance();
    String script =
      "# The next three lines make sure no system gems are loaded.\n" +
      "$:.reject!{|f| !f.start_with?('file:') }\n" +
      "ENV['GEM_HOME'] = nil\n" +
      "ENV['GEM_PATH'] = nil\n" +
      "require 'rubygems'\n" +
      "require 'sass'\n" +
      "require 'java'\n" +
      "require 'org/sass/archive_importer/ClassLoaderImporter'\n" +
      "class_path_importer = ClassLoaderImporter.new\n" +
      "sass_file_contents = %Q{\n" +
      "@import \"css_partial\";\n" +
      "@import \"sass_partial\";\n" +
      "@import \"scss_partial\";\n" +
      "@import \"a_css_file\";\n" +
      "@import \"a_sass_file\";\n" +
      "@import \"a_scss_file\";\n" +
      "@import \"nested/nested\";\n" +
      "}\n" +
      "engine = Sass::Engine.new(sass_file_contents,\n" +
      "                          :syntax => :scss,\n" +
      "                          :filename => 'class_loader_import_test_script.java',\n" +
      "                          :cache => false,\n" +
      "                          :read_cache => false,\n" +
      "                          :load_paths => [class_path_importer])\n" +
      "result = engine.render\n" +
      "fail %Q{Unexpected output: #{result}} unless result == <<CSS\n" +
      ".css-partial {\n" +
      "  color: black; }\n" +
      "\n" +
      ".sass-partial {\n" +
      "  partial: yep; }\n" +
      "\n" +
      ".scss-partial {\n" +
      "  partial: yes; }\n" +
      "\n" +
      ".css-file {\n" +
      "  css: boring; }\n" +
      "\n" +
      ".sass-file {\n" +
      "  indented: yes; }\n" +
      "\n" +
      ".scss-file {\n" +
      "  curly-braces: omg; }\n" +
      "\n" +
      ".deeply-nested {\n" +
      "  deeply: nested; }\n" +
      "\n" +
      ".nested-class {\n" +
      "  nested: yep; }\n" +
      "CSS\n"+
      "\n";
    runtime.evalScriptlet(script);
  }
  public void testClassLoaderImporterModificationTime() {
    final Ruby runtime = Ruby.newInstance();
    String script =
      "# The next three lines make sure no system gems are loaded.\n" +
      "$:.reject!{|f| !f.start_with?('file:') }\n" +
      "ENV['GEM_HOME'] = nil\n" +
      "ENV['GEM_PATH'] = nil\n" +
      "require 'rubygems'\n" +
      "require 'sass'\n" +
      "require 'java'\n" +
      "require 'org/sass/archive_importer/ClassLoaderImporter'\n" +
      "class_path_importer = ClassLoaderImporter.new\n" +
      "entry = class_path_importer.send(:entry_for, 'css_partial')\n" +
      "fail 'expected an mtime' unless entry.time.to_f > 1\n" +
      "fail 'expected an mtime in the past' unless entry.time < Time.now\n" ;
    runtime.evalScriptlet(script);
  }

  public void testClassLoaderImporterNestedContext() {
    final Ruby runtime = Ruby.newInstance();
    String script =
      "# The next three lines make sure no system gems are loaded.\n" +
      "$:.reject!{|f| !f.start_with?('file:') }\n" +
      "ENV['GEM_HOME'] = nil\n" +
      "ENV['GEM_PATH'] = nil\n" +
      "require 'rubygems'\n" +
      "require 'sass'\n" +
      "require 'java'\n" +
      "require 'org/sass/archive_importer/ClassLoaderImporter'\n" +
      "class_path_importer = ClassLoaderImporter.new('sass_files')\n" +
      "sass_file_contents = %Q{\n" +
      "@import \"css_partial\";\n" +
      "@import \"sass_partial\";\n" +
      "@import \"scss_partial\";\n" +
      "@import \"a_css_file\";\n" +
      "@import \"a_sass_file\";\n" +
      "@import \"a_scss_file\";\n" +
      "@import \"nested/nested\";\n" +
      "}\n" +
      "engine = Sass::Engine.new(sass_file_contents,\n" +
      "                          :syntax => :scss,\n" +
      "                          :filename => 'class_loader_import_test_script.java',\n" +
      "                          :cache => false,\n" +
      "                          :read_cache => false,\n" +
      "                          :load_paths => [class_path_importer])\n" +
      "result = engine.render\n" +
      "fail %Q{Unexpected output: #{result}} unless result == <<CSS\n" +
      ".css-partial {\n" +
      "  color: black; }\n" +
      "\n" +
      ".sass-partial {\n" +
      "  partial: yep; }\n" +
      "\n" +
      ".scss-partial {\n" +
      "  partial: yes; }\n" +
      "\n" +
      ".css-file {\n" +
      "  css: boring; }\n" +
      "\n" +
      ".sass-file {\n" +
      "  indented: yes; }\n" +
      "\n" +
      ".scss-file {\n" +
      "  curly-braces: omg; }\n" +
      "\n" +
      ".deeply-nested {\n" +
      "  deeply: nested; }\n" +
      "\n" +
      ".nested-class {\n" +
      "  nested: yep; }\n" +
      "CSS\n"+
      "\n";
    runtime.evalScriptlet(script);
  }

  public void testClassLoaderImporterMissingImport() {
    final Ruby runtime = Ruby.newInstance();
    String script =
      "# The next three lines make sure no system gems are loaded.\n" +
      "$:.reject!{|f| !f.start_with?('file:') }\n" +
      "ENV['GEM_HOME'] = nil\n" +
      "ENV['GEM_PATH'] = nil\n" +
      "require 'rubygems'\n" +
      "require 'sass'\n" +
      "require 'java'\n" +
      "require 'org/sass/archive_importer/ClassLoaderImporter'\n" +
      "class_path_importer = ClassLoaderImporter.new\n" +
      "sass_file_contents = %Q{\n" +
      "@import \"has_missing_import\";\n" +
      "}\n" +
      "engine = Sass::Engine.new(sass_file_contents,\n" +
      "                          :syntax => :scss,\n" +
      "                          :filename => 'class_loader_import_test_script.java',\n" +
      "                          :cache => false,\n" +
      "                          :read_cache => false,\n" +
      "                          :load_paths => [class_path_importer])\n" +
      "begin\n" +
      "  engine.render\n" +
      "  fail 'Exception expected'\n" +
      "rescue => e\n" +
      "  fail 'Expected a Sass::SyntaxError' unless e.is_a?(Sass::SyntaxError)\n" +
      "  fail %Q{expected message but got: #{e.message}} unless e.message == <<MSG.strip\n" +
      "File to import not found or unreadable: this_does_not_exist.\n" +
      "Load path: <ClassLoaderImporter>\n" +
      "MSG\n" +
      "end\n" +
      "\n";
    runtime.evalScriptlet(script);
  }

  public void testClassLoaderImporterWithCompass() {
    final Ruby runtime = Ruby.newInstance();
    String script =
      "# The next three lines make sure no system gems are loaded.\n" +
      "$:.reject!{|f| !f.start_with?('file:') }\n" +
      "ENV['GEM_HOME'] = nil\n" +
      "ENV['GEM_PATH'] = nil\n" +
      "require 'rubygems'\n" +
      "require 'compass'\n" +
      "require 'sass_archive_importer'\n" +
      "sass_file_contents = %Q{\n" +
      "@import \"compass\";\n" +
      ".test { @include border-radius(5px) };\n" +
      "}\n" +
      "engine = Sass::Engine.new(sass_file_contents,\n" +
      "                          :syntax => :scss,\n" +
      "                          :filename => 'class_loader_compass_test.java',\n" +
      "                          :cache => false,\n" +
      "                          :read_cache => false,\n" +
      "                          :load_paths => Compass.configuration.sass_load_paths)\n" +
      "result = engine.render\n" +
      "fail %Q{Unexpected output: #{result}} unless result == <<CSS\n" +
      ".test {\n" +
      "  -webkit-border-radius: 5px;\n" +
      "  -moz-border-radius: 5px;\n" +
      "  -ms-border-radius: 5px;\n" +
      "  -o-border-radius: 5px;\n" +
      "  border-radius: 5px; }\n" +
      "CSS\n"+
      "\n";
    runtime.evalScriptlet(script);
  }

  public static void main(String [] args) {
    ClassLoaderImporterTest test = new ClassLoaderImporterTest();
    test.testClassLoaderImporter();
    test.testClassLoaderImporterNestedContext();
    test.testClassLoaderImporterMissingImport();
    test.testClassLoaderImporterWithCompass();
    test.testClassLoaderImporterModificationTime();
    System.out.println("ALL Java Tests Passed");
  }
}
