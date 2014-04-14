require 'bundler'
require 'bundler/setup'
Bundler::GemHelper.install_tasks

require 'rake/testtask'

def with_env(env)
  old_env = ENV.dup
  ENV.update(env)
  yield
ensure
  ENV.replace(old_env)
end

def execute_or_fail(command, message = "Execution")
  #puts "Executing: #{command}"
  system command
  raise "#{message} failed." unless $?.exitstatus == 0
end

task :test => [:java_test, :mri_test]

directory "test/fixtures/tmpjava"
directory "test/fixtures/tmpjava/org/sass/archive_importer"

file "test/fixtures/tmpjava/specifications/sass-3.2.19.gemspec" => "test/fixtures/tmpjava" do
  cwd = Dir.getwd
  Dir.chdir ".." do
    # this is done withing a chdir because the Gemfile in this folder was causing issues
    execute_or_fail("gem install sass-archive-importer/test/fixtures/sass-3.2.19.gem -i #{cwd}/test/fixtures/tmpjava  --no-rdoc --no-ri",
                    "Sass 3.2 Install")
  end
end

file "test/fixtures/tmpjava/org/sass/archive_importer/ClassLoaderImporter.rb" => 
       %w(test/fixtures/tmpjava/org/sass/archive_importer
          lib/org/sass/archive_importer/ClassLoaderImporter.rb) do
  FileUtils.cp "lib/org/sass/archive_importer/ClassLoaderImporter.rb",
               "test/fixtures/tmpjava/org/sass/archive_importer"
end


desc "Compile the Ruby class to Java using JRuby"
file "test/fixtures/tmpjava/org/sass/archive_importer/ClassLoaderImporter.class" =>
     %w(test/fixtures/tmpjava
        test/fixtures/tmpjava/org/sass/archive_importer) +
     FileList["test/fixtures/tmpjava/org/sass/archive_importer/ClassLoaderImporter.rb"] do
  Dir.chdir("test/fixtures/tmpjava") do
    # I don't know how to make jruby compile correctly to a target folder correctly.
    execute_or_fail("jrubyc --javac org/sass/archive_importer/ClassLoaderImporter.rb",
                    "JRuby compilation")
  end
end

desc "Copy sass artifacts to the jar directory"
task :copy_sass_artifacts do
  FileUtils.cp_r Dir.glob("test/fixtures/zipped_files/*"), "test/fixtures/tmpjava"
  FileUtils.cp_r "test/fixtures/zipped_files", "test/fixtures/tmpjava/sass_files"
end

desc "Build the java test jar"
file "test/fixtures/class_loader_importer_test.jar" => 
     %w(test/fixtures/tmpjava/org/sass/archive_importer/ClassLoaderImporter.rb
        test/fixtures/tmpjava/specifications/sass-3.2.19.gemspec) +
      FileList["test/fixtures/zipped_files/**/*"] +
      FileList["test/class_loader_importer_test.java"] +
     [:copy_sass_artifacts] do

   execute_or_fail("javac -Xlint:deprecation -cp test/fixtures/tmpjava:test/fixtures/jruby-complete-1.6.5.jar test/class_loader_importer_test.java -d test/fixtures/tmpjava",
                   "Java compilation")
   execute_or_fail("jar -cf test/fixtures/class_loader_importer_test.jar -C test/fixtures/tmpjava .",
                   "Jar creation")
 end

 desc "Run java tests"
 task :java_test => "test/fixtures/class_loader_importer_test.jar" do
   execute_or_fail("java -cp test/fixtures/jruby-complete-1.6.5.jar:test/fixtures/class_loader_importer_test.jar ClassLoaderImporterTest",
                   "Java test")
 end

Rake::TestTask.new(:mri_test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/*_test.rb'
  t.verbose = false
end
task :mri_test => ["test/fixtures/zipped_files.zip", "test/fixtures/jarred_files.jar"]

desc "Build the zip file fixture."
file "test/fixtures/zipped_files.zip" => FileList["test/fixtures/zipped_files/**/*"] do
  puts "Zipping test/fixtures/zipped_files/"
  Dir.chdir "test/fixtures/zipped_files" do
    `zip -r ../zipped_files.zip .`
    raise "failed to create test/fixtures/zipped_files.zip" unless $? == 0
  end
end

desc "Build the jar file fixture."
file "test/fixtures/jarred_files.jar" => FileList["test/fixtures/zipped_files/**/*"] do
  puts "Jarring test/fixtures/zipped_files/"
  `jar -cf test/fixtures/jarred_files.jar -C test/fixtures/zipped_files .`
  raise "failed to create test/fixtures/zipped_files.zip" unless $? == 0
end

desc "Remove files generated during build or testing"
task :clean do
  FileUtils.rm_f "test/fixtures/jarred_files.jar"
  FileUtils.rm_f "test/fixtures/zipped_files.zip"
  FileUtils.rm_f "test/fixtures/class_loader_importer_test.jar"
  FileUtils.rm_rf "test/fixtures/tmpjava"
end

