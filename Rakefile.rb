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

# ------------------------- Test Tasks.

lucie_filelist = FileList['test/lucie/tc_*.rb']
debconf_filelist = FileList['test/debconf/tc_*.rb']
deft_filelist = FileList['test/deft/tc_*.rb']
lmp_filelist = FileList['test/lmp/tc_*.rb']
alltest_filelist = FileList.new
alltest_filelist << lucie_filelist << debconf_filelist << deft_filelist << lmp_filelist

desc "Run all the unit tests."
Rake::TestTask.new( :testall ) do |t|
  t.test_files = alltest_filelist
  t.verbose = true
end

Rake::TestTask.new( :test_lucie ) do |t|
  t.test_files = lucie_filelist
  t.verbose = true
end

Rake::TestTask.new( :test_debconf ) do |t|
  t.test_files = debconf_filelist
  t.verbose = true
end

Rake::TestTask.new( :test_deft ) do |t|
  t.test_files = deft_filelist
  t.verbose = true
end

Rake::TestTask.new( :test_lmp ) do |t|
  t.test_files = lmp_filelist
  t.verbose = true
end

# ------------------------- RDoc Tasks.

Rake::RDocTask.new( :rdoc ) do |rdoc|
  rdoc.title = 'Lucie documentation'
  rdoc.rdoc_dir = 'doc/rdoc'
  rdoc.options << '--line-numbers' 
  rdoc.options << '--inline-source' 
  rdoc.options << '--charset' << 'sjis' 
  rdoc.options << '--diagram'
  rdoc.rdoc_files.include( 'lib/*.rb', 'lib/debconf/*.rb', 'lib/deft/*.rb', 
                           'lib/lucie/*.rb', 'lib/lucie/config/*.rb', 'lib/lmp/*.rb', 
                           'lib/lucie/rake/*.rb' )
end

# ------------------------- Installation Tasks.

# Install Lucie using the standard install.rb script.

desc 'Install the application'
task :install do 
  ruby 'install.rb'
end

# ------------------------- Package Tasks.

desc 'Build Debian Packages'
task :deb do 
  sh %{debuild || true}
end

desc 'Upload Debian Packages'
task :upload => [:deb] do
  sh %{cd .. && apt-ftparchive packages . | gzip -c9 > Packages.gz}
  sh %{cd .. && apt-ftparchive sources  . | gzip -c9 > Sources.gz}
  sh %{cd .. && scp Packages.gz Sources.gz lucie-client*.deb *.dsc *.tar.gz *.build lucie.sourceforge.net:/home/groups/l/lu/lucie/htdocs/packages/lucie-client/sarge/ }
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
