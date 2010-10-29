require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "texas_holdem"
    gem.summary = %Q{TODO: one-line summary of your gem}
    gem.description = %Q{TODO: longer description of your gem}
    gem.email = "keith@dancingtext.com"
    gem.homepage = "http://github.com/kmcd/texas_holdem"
    gem.authors = ["Keith McDonnell"]
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "texas_holdem #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc 'Create class & unit test'
task :class, :name do |task,args|
  class_name = args.name.capitalize
  file_name  = args.name.downcase
  
  write_to "lib/#{file_name}.rb", %Q{class TexasHoldem::#{class_name}
end}

  write_to "test/test_#{file_name}.rb", %Q{require 'helper'
class #{class_name}Test < Test::Unit::TestCase
  def setup
  end
  
  test "should " do
    flunk
  end
end}
end

def write_to(local_filename,text)
  File.open(local_filename, 'w') {|f| f.write(text) }
end
