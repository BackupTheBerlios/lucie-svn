#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'rake/clean'
require 'rake/testtask'
require 'rake/rdoctask'

desc "Default Task"
task :default => [:test]

# Test Tasks -------------------------------------------------------------------

desc "Run all the unit tests."
Rake::TestTask.new( :test ) do |t|
  t.test_files = FileList['test/tc_setup.rb', 'test/tc_command-line-options.rb']
  t.verbose = true
end

# RDoc Tasks -------------------------------------------------------------------

Rake::RDocTask.new( :rdoc ) do |rdoc|
  rdoc.title = 'Lucie documentation'
  rdoc.rdoc_dir = 'doc'
  rdoc.options << '--line-numbers' << '--inline-source' << '--charset' << 'sjis' << '--diagram'
  rdoc.rdoc_files.include( 'lib/lucie/command-line-options.rb' )
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
