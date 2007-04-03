#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'rake/clean'
require 'rake/rdoctask'
require 'rake/testtask'
require 'rcov/rcovtask'


REQUIRE_PATHS = [ 'lib', 'test', 'test/popen3', 'test/lucie', 'test/install-packages' ]

TEST_VERBOSITY = true
TEST_FILES_INSTALL_PACKAGES = [ 'test/install-packages/ts_all.rb' ]

TEST_FILES_HARDDISK = FileList[ 'test/setup-harddisk/tc_*.rb' ]
TEST_FILES_LIBPOPEN3 = [ 'test/popen3/ts_all.rb' ]
TEST_FILES_LUCIE = [ "test/lucie/ts_all.rb" ]
TEST_FILES_LMP = FileList[ "test/lmp/tc_*.rb" ]
TEST_FILES_LIBDEPENDS = FileList[ "test/depends/tc_*.rb" ]
TEST_FILES_DEFT = [ "test/deft/test_all.rb" ]
TEST_FILES_DEBCONF = FileList[ "test/debconf/tc_*.rb" ]

$stderr.puts "WARNING: lucie-vm-pool test suite is temporally disabled."
$stderr.puts "WARNING: Lucie test suite is temporally disabled."
$stderr.puts "WARNING: Deft test suite is temporally disabled."
$stderr.puts "WARNING: LMP test suite is temporally disabled."
$stderr.puts "WARNING: libdepends test suite is temporally disabled."

TEST_FILES = TEST_FILES_INSTALL_PACKAGES + TEST_FILES_DEBCONF + TEST_FILES_HARDDISK + TEST_FILES_LIBPOPEN3

LMP_SERVER_DIR  = %{/var/www/}
LMP_SERVER      = %{lucie-dev.titech.hpcc.jp}
LMP_SERVER_URI  = LMP_SERVER + ':' + LMP_SERVER_DIR


# Default Task #################################################################

desc "Default Task"
task :default => [ :test ]


# Test Task ####################################################################

desc "Run all the unit tests."
Rake::TestTask.new( :test ) do | t |
  t.test_files = TEST_FILES
  t.libs = REQUIRE_PATHS
  t.verbose = TEST_VERBOSITY
end


# Test Coverage Task ###########################################################

desc "Output a unit test coverage report"
Rcov::RcovTask.new do | t |
  t.rcov_opts = [ '-xRakefile', '--text-report' ]
  t.libs = REQUIRE_PATHS
  t.test_files = TEST_FILES
  t.verbose = true
end


# RDoc Task ####################################################################

Rake::RDocTask.new( :rdoc ) do |rdoc|
  rdoc.title = 'Lucie documentation'
  rdoc.template = 'html'
  rdoc.rdoc_dir = 'doc/rdoc'
  rdoc.options << '--line-numbers'
  rdoc.options << '--inline-source'
  rdoc.options << '--charset' << 'eucjp'
  # rdoc.options << '--diagram'
  rdoc.rdoc_files = FileList[ 'lib/**/*.rb' ]
end

desc 'Upload rdoc documents'
task :upload_rdoc => [:rdoc] do
  sh %{tar --directory doc -czf web.tar rdoc images}
  sh %{scp web.tar #{LMP_SERVER_URI}}
  sh %{ssh -l takamiya #{LMP_SERVER} "cd #{LMP_SERVER_DIR} && tar xzf web.tar"}
end


# ------------------------- Installation Tasks.

# Install Lucie using the standard install.rb script.
desc 'Install the application'
task :install do 
  ruby 'install.rb'
end

# ------------------------- Package Tasks.

# rake TESTING=true targets...
# でテスト用ディレクトリにアップロード
def server_uri( pathString )
  if ENV['TESTING']
    return File.join( LMP_SERVER_URI, 'testing', pathString )
  else
    return File.join( LMP_SERVER_URI, pathString )
  end
end

# Build Debian packages of Lucie.
# For information about packages, see debian/control.
desc 'Lucie パッケージのビルド'
task :deb do 
  sh %{debuild || true}
end

# FIXME: :upload_lmp should depend to :build_lmp?
desc 'Lucie メタパッケージのアップロード'
task :upload_lmp do
  tmp_dir = '../upload/lmp'
  scp_targets = %{Packages *.gz *.dsc *.deb *.build *.changes}
  scp_destination = server_uri( 'packages/lmp' )
  
  mkdir_p tmp_dir
  cp FileList["data/lmp/*.gz"].to_ary, tmp_dir
  cp FileList["data/lmp/*.dsc"].to_ary, tmp_dir
  cp FileList["data/lmp/*.deb"].to_ary, tmp_dir
  cp FileList["data/lmp/*.build"].to_ary, tmp_dir
  cp FileList["data/lmp/*.changes"].to_ary, tmp_dir
  sh %{cd #{tmp_dir} && apt-ftparchive packages . > Packages}
  sh %{cd #{tmp_dir} && gzip -c9 Packages > Packages.gz}
  sh %{cd #{tmp_dir} && apt-ftparchive sources  . | gzip -c9 > Sources.gz}
  sh %{cd #{tmp_dir} && scp #{scp_targets} #{scp_destination}}
end

# FIXME: divide into upload_deb and upload_rpm(?)
# TODO: support woody and other versions.
desc 'Lucie パッケージのアップロード'
task :upload_lucie => [:deb] do
  tmp_dir = '../upload/lucie/'
  scp_destination = server_uri( 'packages/lucie/debian/sarge' )
  mkdir_p tmp_dir
  sh %{mv ../lucie_*.deb    #{tmp_dir}}
  sh %{mv ../lucie_*.dsc    #{tmp_dir}}
  sh %{mv ../lucie_*.tar.gz #{tmp_dir}}
  sh %{mv ../lucie_*.build  #{tmp_dir}}
  sh %{cd #{tmp_dir} && apt-ftparchive packages . | gzip -c9 > Packages.gz}
  sh %{cd #{tmp_dir} && apt-ftparchive sources  . | gzip -c9 > Sources.gz}
  sh %{cd #{tmp_dir} && scp * #{scp_destination}}
end

# TODO: support sarge and other versions.
desc 'Lucie クライアント関連パッケージのアップロード'
task :upload_lucie_client => [:deb] do 
  tmp_dir = '../upload/lucie-client'
  scp_destination = server_uri( 'packages/lucie-client/debian/sarge/' )
  mkdir_p tmp_dir
  sh %{mv ../lucie-client*.deb #{tmp_dir}}
  sh %{cd #{tmp_dir} && apt-ftparchive packages . | gzip -c9 > Packages.gz}
  sh %{cd #{tmp_dir} && apt-ftparchive sources  . | gzip -c9 > Sources.gz}
  sh %{cd #{tmp_dir} && scp * #{scp_destination}}
end

desc 'Deft パッケージのアップロード'
task :upload_deft => [:deb] do
  tmp_dir = '../upload/lucie/'
  scp_destination = server_uri( 'packages/lucie/debian/sarge' )
  mkdir_p tmp_dir
  sh %{mv ../deft_*.deb    #{tmp_dir}}
  sh %{cd #{tmp_dir} && apt-ftparchive packages . | gzip -c9 > Packages.gz}
  sh %{cd #{tmp_dir} && apt-ftparchive sources  . | gzip -c9 > Sources.gz}
  sh %{cd #{tmp_dir} && scp * #{scp_destination}}
end

desc 'Lucie/Lucie クライアント/rdoc ドキュメントのアップロード'
task :upload => [:upload_lucie, :upload_lucie_client, :upload_rdoc]

# ------------------------- Other Tasks.

# タスク管理/表示用簡易ターゲット:

desc 'ソースコード中の todo タスクを表示'
task :todo do
  sh %{find . -name '*.rb' | grep -v './debian/' | xargs grep -n 'TODO'  -}
end

desc 'ソースコード中の fixme タスクを表示'
task :fixme do
  sh %{find . -name '*.rb' | grep -v './debian/' | xargs grep -n 'FIXME' -}
end

desc 'Cのソースコードをコンパイルする'
file "vmlucie-compile" => ["vmlucie-setup.o"] do |t|
    sh %{gcc -o bin/vmlucie-setup src/vmlucie-setup.o}; 
end

file "vmlucie-setup.o" => ["src/vmlucie-setup.c"] do |t|
    sh %{gcc -c -o src/vmlucie-setup.o src/vmlucie-setup.c};
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
