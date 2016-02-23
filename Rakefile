# encoding: utf-8
require 'rake/testtask'

Rake::TestTask.new do |t|
  ENV["RAILS_ENV"] = "test"
  t.libs << 'test'
end

desc "Run tests"
task :default => :test
