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
  mkdir_p '../upload/lucie/'
  sh %{mv ../lucie_*.deb ../upload/lucie/}
  sh %{mv ../lucie_*.dsc ../upload/lucie/}
  sh %{mv ../lucie_*.tar.gz ../upload/lucie/}
  sh %{mv ../lucie_*.build ../upload/lucie/}
  sh %{cd ../upload/lucie/ && apt-ftparchive packages . | gzip -c9 > Packages.gz}
  sh %{cd ../upload/lucie/ && apt-ftparchive sources  . | gzip -c9 > Sources.gz}
  sh %{cd ../upload/lucie/ && scp * lucie.sourceforge.net:/home/groups/l/lu/lucie/htdocs/packages/lucie/debian/sarge/ }

  mkdir_p '../upload/lucie-client'
  sh %{mv ../lucie-client*.deb ../upload/lucie-client/}
  sh %{cd ../upload/lucie-client/ && apt-ftparchive packages . | gzip -c9 > Packages.gz}
  sh %{cd ../upload/lucie-client/ && apt-ftparchive sources  . | gzip -c9 > Sources.gz}
  sh %{cd ../upload/lucie-client/ && scp * lucie.sourceforge.net:/home/groups/l/lu/lucie/htdocs/packages/lucie-client/debian/woody/ }
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
