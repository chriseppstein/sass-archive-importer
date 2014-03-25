require 'bundler'
Bundler::GemHelper.install_tasks

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

task :test => ["test/fixtures/zipped_files.zip", "test/fixtures/jarred_files.jar"]

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
