# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "basketball_pbp"
  gem.homepage = "http://github.com/mharris717/basketball_pbp"
  gem.license = "MIT"
  gem.summary = %Q{basketball_pbp}
  gem.description = %Q{basketball_pbp}
  gem.email = "mharris717@gmail.com"
  gem.authors = ["Mike Harris"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "basketball_pbp #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :load_lib do
  load "lib/basketball_pbp.rb"
end

task :save_raw_old => [:load_lib] do
  BasketballPbp::PBPFile.all.each { |x| x.save! }
end

task :save_raw => [:load_lib] do
  puts BasketballPbp::PBPFile.coll.count

  #filename = "data/AllData201203032316/sample_pbp.txt"
  filename = "data/AllData201203032316/playbyplay201203032316.txt"

  file = BasketballPbp::PBPFile::RawFile.new(:path => filename)
  file.save!

  puts BasketballPbp::PBPFile.coll.count
end