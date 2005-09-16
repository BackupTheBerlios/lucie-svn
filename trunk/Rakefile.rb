#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

require 'rake/clean'
require 'rake/rdoctask'
require 'rake/testtask'

SOURCEFORGE_DIR  = %{/home/groups/l/lu/lucie/htdocs/}
SOURCEFORGE_HOST = %{lucie.sourceforge.net}
SOURCEFORGE_URI  = SOURCEFORGE_HOST + ':' + SOURCEFORGE_DIR

desc "Default Task"
task :default => [:testall]

# ------------------------- Test Tasks.

# テスト出力の冗長性
TEST_VERBOSITY = true 

# テストに含まれる全テストスイート
TEST_SUITES = ['lucie', 'debconf', 'deft', 'lmp', 'depends', 'install_packages']

# すべてのテストは $(TOPDIR)/test/$(テストスイート名)/ というディレクトリを作り
# tc_*.rb という名前のテストケースに作成する
def testcase_filelist( testNameString )
  return FileList[File.join('test', testNameString, 'tc_*.rb')]
end

desc "Run all the unit tests."
Rake::TestTask.new( :testall ) do |t|
  all_tests = FileList.new
  TEST_SUITES.each do |each|
    all_tests << testcase_filelist( each )
  end
  t.libs << "lib" << "test"
  t.test_files = all_tests
  t.verbose = TEST_VERBOSITY
end

TEST_SUITES.each do |each|
  Rake::TestTask.new( %{test_#{each}}.intern ) do |t|
    t.test_files = testcase_filelist( each )
    t.verbose = TEST_VERBOSITY
  end
end

# ------------------------- RDoc Tasks.

Rake::RDocTask.new( :rdoc ) do |rdoc|
  rdoc.title = 'Lucie documentation'
  rdoc.template = 'jamis'
  rdoc.rdoc_dir = 'doc/rdoc'
  rdoc.options << '--line-numbers' 
  rdoc.options << '--inline-source' 
  rdoc.options << '--charset' << 'eucjp' 
  # rdoc.options << '--diagram'
  rdoc.rdoc_files.include( 'lib/*.rb', 'lib/debconf/*.rb', 'lib/deft/*.rb', 'lib/depends/*.rb',
                           'lib/lucie/*.rb', 'lib/lucie/config/*.rb', 'lib/lmp/*.rb', 
                           'data/lmp/default/*.rb', 'data/lmp/compile/*.rb', 
                           'data/lmp/lilo/*.rb', 'data/lmp/network/*.rb',
                           'bin/install_packages',
                           'lib/lucie/rake/*.rb' )
end

desc 'Upload rdoc documents'
task :upload_rdoc => [:rdoc] do
  sh %{tar --directory doc -czf web.tar rdoc images}
  sh %{scp web.tar #{SOURCEFORGE_URI}}
  sh %{ssh -l takamiya #{SOURCEFORGE_HOST} "cd #{SOURCEFORGE_DIR} && tar xzf web.tar"}   
end

# ------------------------- Installation Tasks.

# Install Lucie using the standard install.rb script.
desc 'Install the application'
task :install do 
  ruby 'install.rb'
end

# ------------------------- Package Tasks.

# Build Debian packages of Lucie.
# For information about packages, see debian/control.
desc 'Lucie パッケージのビルド'
task :deb do 
  sh %{debuild || true}
end

# FIXME: :upload_lmp should depend to :build_lmp?
desc 'Lucie メタパッケージのアップロード'
task :upload_lmp do
  tmp_dir = %{data/lmp}
  scp_targets = %{*.gz *.dsc *.deb *.build *.changes}
  scp_destination = File.join( SOURCEFORGE_URI, 'packages/lmp' )
  sh %{cd #{tmp_dir} && apt-ftparchive packages . | gzip -c9 > Packages.gz}
  sh %{cd #{tmp_dir} && apt-ftparchive sources  . | gzip -c9 > Sources.gz}
  sh %{cd #{tmp_dir} && scp #{scp_targets} #{scp_destination}}
end

# FIXME: divide into upload_deb and upload_rpm(?)
# TODO: support woody and other versions.
desc 'Lucie パッケージのアップロード'
task :upload_lucie => [:deb] do
  tmp_dir = '../upload/lucie/'
  scp_destination = File.join( SOURCEFORGE_URI, 
                               'packages/lucie/debian/sarge' )
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
  scp_destination = File.join( SOURCEFORGE_URI,
                               'packages/lucie-client/debian/sarge/' )
  mkdir_p tmp_dir
  sh %{mv ../lucie-client*.deb #{tmp_dir}}
  sh %{cd #{tmp_dir} && apt-ftparchive packages . | gzip -c9 > Packages.gz}
  sh %{cd #{tmp_dir} && apt-ftparchive sources  . | gzip -c9 > Sources.gz}
  sh %{cd #{tmp_dir} && scp * #{scp_destination}}
end

desc 'Deft パッケージのアップロード'
task :upload_deft => [:deb] do
  tmp_dir = '../upload/lucie/'
  scp_destination = File.join( SOURCEFORGE_URI, 
                               'packages/lucie/debian/sarge' )
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

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
