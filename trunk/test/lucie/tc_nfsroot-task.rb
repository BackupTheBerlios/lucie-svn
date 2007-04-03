#!/usr/bin/env ruby
#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2


$LOAD_PATH.unshift( '../../lib' ) if __FILE__ =~ /\.rb$/


require 'rubygems'
require 'rake'
require 'rake/classic_namespace'
require 'lucie/nfsroot-task'
require 'test/unit'


class TC_NfsrootTask < Test::Unit::TestCase
  def setup
    Task.clear
  end


  def teardown
    Task.clear
  end


  def test_accessor
    nfsroot_task = Rake::NfsrootTask.new do | task |
      task.name = 'NFSROOT'
      task.mirror = 'HTTP://WWW.DEBIAN.OR.JP/DEBIAN/'
      task.target_directory = '/TMP/NFSROOT'
      task.distribution = 'DEBIAN'
      task.suite = 'SARGE'
      task.extra_packages = [ 'EXTRA_PACKAGE_1', 'EXTRA_PACKAGE_2' ]
      task.kernel_package = 'KERNEL.DEB'
      task.root_password = 'XXXXXXXX'
    end

    assert_equal 'NFSROOT', nfsroot_task.name
    assert_equal 'HTTP://WWW.DEBIAN.OR.JP/DEBIAN/', nfsroot_task.mirror
    assert_equal '/TMP/NFSROOT', nfsroot_task.target_directory
    assert_equal 'DEBIAN', nfsroot_task.distribution
    assert_equal 'SARGE', nfsroot_task.suite
    assert_equal [ 'EXTRA_PACKAGE_1', 'EXTRA_PACKAGE_2' ], nfsroot_task.extra_packages
    assert_equal 'KERNEL.DEB', nfsroot_task.kernel_package
    assert_equal 'XXXXXXXX', nfsroot_task.root_password
  end


  def test_all_targets_defined
    nfsroot_task = Rake::NfsrootTask.new do | task |
      task.name = 'NFSROOT'
      task.mirror = 'HTTP://WWW.DEBIAN.OR.JP/DEBIAN/'
      task.target_directory = '/TMP/NFSROOT'
      task.distribution = 'DEBIAN'
      task.suite = 'SARGE'
      task.extra_packages = [ 'EXTRA_PACKAGE_1', 'EXTRA_PACKAGE_2' ]
      task.kernel_package = 'KERNEL.DEB'
      task.root_password = 'XXXXXXXX'
    end

    assert_kind_of Rake::Task, Task[ 'NFSROOT' ]
    assert_kind_of Rake::Task, Task[ 'reNFSROOT' ]
    assert_kind_of Rake::Task, Task[ 'clobber_NFSROOT' ]
    assert_kind_of Rake::Task, Task[ '/TMP/NFSROOT' ]
    assert_kind_of Rake::Task, Task[ :installer_base ]
    assert_kind_of Rake::Task, Task[ :reinstaller_base ]
    assert_kind_of Rake::Task, Task[ '/var/lib/lucie/installer_base/DEBIAN_SARGE.tgz' ]

#     assert_equal( "Build the nfsroot filesytem using debian_woody.tgz",
#                   Task[:nfsroot].comment, 
#                   ":nfsroot タスクのコメントが設定されていない" )
    
#     assert_not_nil( Task['/var/lib/lucie/nfsroot/'],
#                     '/var/lib/lucie/nfsroot/ ディレクトリタスクが定義されていない' )
                    
#     assert_not_nil( Task['/var/lib/lucie/nfsroot/lucie/timestamp'],
#                     '/var/lib/lucie/nfsroot/lucie/timestamp ファイルタスクが定義されていない' )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
