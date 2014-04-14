//import org.sass.archive_importer.ClassLoaderImporter;
import org.jruby.Ruby;

class ClassLoaderImporterTest {
  //public void testJavaInstantiation() {
    //ClassLoaderImporter importer = new ClassLoaderImporter(null);
  //}

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

  public static void main(String [] args) {
    ClassLoaderImporterTest test = new ClassLoaderImporterTest();
    //test.testJavaInstantiation();
    test.testClassLoaderImporter();
    System.out.println("ALL Java Tests Passed");
  }
}
