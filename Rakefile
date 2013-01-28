#!/usr/bin/env rake
require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs.push "lib"
  t.test_files = FileList['test/csv_record/*_test.rb', 'test/monkey_patches/*_test.rb']
  t.verbose = false
end

desc "Run tests"
task default: :test