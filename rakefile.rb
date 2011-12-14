require "bundler"
require "rspec/core/rake_task"
require "rake/rdoctask"

Bundler::GemHelper.install_tasks

Rake::RDocTask.new(:rdoc_dev) do |rd|
  rd.rdoc_files.include("lib/**/*.rb", "README.rdoc")
  rd.options + ['-a', '--inline-source', '--charset=UTF-8']
end

RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = ["--format Fuubar", "--color"]
  t.pattern = 'spec/**/*_spec.rb'
end

task :default=>:spec
