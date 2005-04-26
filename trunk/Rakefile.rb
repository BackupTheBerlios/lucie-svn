#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'rake/clean'
require 'rake/testtask'
require 'rake/rdoctask'

$sourceforge_host = %{lucie.sourceforge.net}
$sourceforge_dir  = %{/home/groups/l/lu/lucie/htdocs/}
$sourceforge_uri  = $sourceforge_host + ':' + $sourceforge_dir

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
  rdoc.options << '--charset' << 'eucjp' 
  rdoc.options << '--diagram'
  rdoc.rdoc_files.include( 'lib/*.rb', 'lib/debconf/*.rb', 'lib/deft/*.rb', 
                           'lib/lucie/*.rb', 'lib/lucie/config/*.rb', 'lib/lmp/*.rb', 
                           'data/lmp/compile/*.rb',
                           'lib/lucie/rake/*.rb' )
end

desc 'Upload rdoc documents'
task :upload_rdoc => [:rdoc] do
  sh %{tar --directory doc -czf web.tar rdoc}
  sh %{scp web.tar #{$sourceforge_uri}}
  sh %{ssh -l takamiya #{$sourceforge_host} "cd #{$sourceforge_dir} && tar xzf web.tar"}   
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

desc 'Upload LMP'
task :upload_lmp do
  tmp_dir = %{data/lmp}
  scp_targets = %{*.gz *.dsc *.deb *.build *.changes}
  scp_destination = File.join( $sourceforge_uri, 'packages/lmp' )
  sh %{cd #{tmp_dir} && apt-ftparchive packages . | gzip -c9 > Packages.gz}
  sh %{cd #{tmp_dir} && apt-ftparchive sources  . | gzip -c9 > Sources.gz}
  sh %{cd #{tmp_dir} && scp #{scp_targets} #{scp_destination}}
end

task :upload_lucie => [:deb] do
  tmp_dir = '../upload/lucie/'
  scp_destination = File.join( $sourceforge_uri, 'packages/lucie/debian/sarge' )
  mkdir_p tmp_dir
  sh %{mv ../lucie_*.deb    #{tmp_dir}}
  sh %{mv ../lucie_*.dsc    #{tmp_dir}}
  sh %{mv ../lucie_*.tar.gz #{tmp_dir}}
  sh %{mv ../lucie_*.build  #{tmp_dir}}
  sh %{cd #{tmp_dir} && apt-ftparchive packages . | gzip -c9 > Packages.gz}
  sh %{cd #{tmp_dir} && apt-ftparchive sources  . | gzip -c9 > Sources.gz}
  sh %{cd #{tmp_dir} && scp * #{scp_destination}}
end

task :upload_lucie_client => [:deb] do 
  tmp_dir = '../upload/lucie-client'
  scp_destination = File.join( $sourceforge_uri, 'packages/lucie-client/debian/woody/' )
  scp_destination = %{lucie.sourceforge.net:/home/groups/l/lu/lucie/htdocs/}
  mkdir_p tmp_dir
  sh %{mv ../lucie-client*.deb #{tmp_dir}}
  sh %{cd #{tmp_dir} && apt-ftparchive packages . | gzip -c9 > Packages.gz}
  sh %{cd #{tmp_dir} && apt-ftparchive sources  . | gzip -c9 > Sources.gz}
  sh %{cd #{tmp_dir} && scp * #{scp_destination}}
end

desc 'Upload Debian Packages and rdoc documents'
task :upload => [:upload_lucie, :upload_lucie_client, :upload_rdoc]

# ------------------------- Other Tasks.

desc 'Show TODOs'
task :todo do
  sh %{find . -name '*.rb' | grep -v './debian/' | xargs grep 'TODO' -}
end

desc 'Show FIXMEs'
task :fixme do
  sh %{find . -name '*.rb' | grep -v './debian/' | xargs grep 'FIXME' -}
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
