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
task :default => [:testall]

# Test Tasks -------------------------------------------------------------------

desc "Run all the unit tests."
Rake::TestTask.new( :testall ) do |t|
  t.test_files = FileList['test/tc_*.rb']
  t.verbose = true
end

Rake::TestTask.new(:testtask) do |t|
  t.test_files = FileList['test/tc_task_*.rb']
  t.verbose = true
end


# RDoc Tasks -------------------------------------------------------------------

Rake::RDocTask.new( :rdoc ) do |rdoc|
  rdoc.title = 'Lucie documentation'
  rdoc.rdoc_dir = 'doc'
  rdoc.options << '--line-numbers' << '--inline-source' << '--charset' << 'sjis' << '--diagram'
  rdoc.rdoc_files.include( 'lib/*.rb', 'lib/deft/*.rb', 'lib/lucie/*.rb', 'lib/lucie/rake/*.rb' )
end

# templates ‚Ì¶¬ -------------------------------------------------------------

desc 'templates ‚Ì¶¬'
task :templates do
  $LOAD_PATH.unshift './lib'
  $LOAD_PATH.unshift './data'
  require 'lucie_vm_template'
  File::open( 'templates', 'w' ) do |file|
    Lucie::Template::TEMPLATES.values.each do |each|
      file.puts each
      file.puts
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
