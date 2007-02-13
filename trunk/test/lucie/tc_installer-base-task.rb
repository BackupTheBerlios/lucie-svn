#
# $Id$
#
# Author:: Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License:: GPL2


$LOAD_PATH.unshift( '../../lib' ) if __FILE__ =~ /\.rb$/


require 'rubygems'
require 'flexmock'
require 'rake'
require 'lucie/installer-base-task'
require 'test/unit'


class TC_InstallerBaseTask < Test::Unit::TestCase
  include FlexMock::TestCase


  def setup
    Task.clear
  end


  def teardown
    Task.clear
  end


  def test_accessor
    installer_base_task = Rake::InstallerBaseTask.new do | task |
      task.target_directory = '/TMP'
      task.mirror = 'HTTP://WWW.DEBIAN.OR.JP/DEBIAN/'
      task.distribution = 'DEBIAN'
      task.suite = 'SARGE'
    end
    assert_equal :installer_base, installer_base_task.name
    assert_equal '/TMP', installer_base_task.target_directory
    assert_equal 'HTTP://WWW.DEBIAN.OR.JP/DEBIAN/', installer_base_task.mirror
    assert_equal 'DEBIAN', installer_base_task.distribution
    assert_equal 'SARGE', installer_base_task.suite
  end


  def test_all_targets_defined
    Rake::InstallerBaseTask.new do | task |
      task.target_directory = '/TMP'
      task.mirror = 'HTTP://WWW.DEBIAN.OR.JP/DEBIAN/'
      task.distribution = 'DEBIAN'
      task.suite = 'SARGE'
    end

    assert_kind_of Rake::Task, Task[ :installer_base ]
    assert_kind_of Rake::Task, Task[ :reinstaller_base ]
    assert_kind_of Rake::Task, Task[ '/TMP' ]
    assert_kind_of Rake::Task, Task[ '/TMP/DEBIAN_SARGE.tgz' ]

    assert_equal( "Build installer base tarball for DEBIAN distribution, version = ``SARGE''.", Task[ :installer_base ].comment )
    assert_equal( "Force a rebuild of the installer base tarball.", Task[ :reinstaller_base ].comment )
  end


  def test_installer_base_target_prerequisites
    Rake::InstallerBaseTask.new do | task |
      task.target_directory = '/TMP/'
      task.distribution = 'DEBIAN'
      task.suite = 'WOODY'
    end
    assert_equal [ '/TMP/DEBIAN_WOODY.tgz' ], Task[ :installer_base ].prerequisites
  end


  def test_reinstaller_base_target_prerequisites
    Rake::InstallerBaseTask.new do | task |
      task.distribution = 'DEBIAN'
      task.suite = 'WOODY'
    end
    assert_equal [ "clobber_installer_base", "installer_base" ], Task[ :reinstaller_base ].prerequisites
  end


  def test_installer_base_target
    flexstub( Shell, 'SHELL_CLASS' ).should_receive( :open ).with( Proc ).once.ordered.and_return do | block |
      flexmock( 'SHELL' ) do | shell |
        shell.should_receive( :on_stdout ).with( Proc ).once.ordered.and_return do | stdout_block |
          stdout_block.call 'ii  debootstrap    0.2.45-0.2     Bootstrap a basic Debian system'
        end
        shell.should_receive( :exec ).with( { 'LC_ALL' => 'C' }, 'dpkg', '-l' ).once.ordered
        block.call shell
      end
    end
    flexstub( Debootstrap, 'DEBOOTSTRAP' ).should_receive( :new ).with( Proc ).once.ordered.and_return do | block |
      debootstrap_option_mock = flexmock( 'DEBOOTSTRAP_OPTION' )
      debootstrap_option_mock.should_receive( :env= ).with( { 'http_proxy' => nil, 'LC_ALL' => 'C' } ).once.ordered
      debootstrap_option_mock.should_receive( :exclude= ).with( [ 'dhcp-client', 'info' ] ).once.ordered
      debootstrap_option_mock.should_receive( :suite= ).with( 'SARGE' ).once.ordered
      debootstrap_option_mock.should_receive( :target= ).with( '/TMP' ).once.ordered
      debootstrap_option_mock.should_receive( :mirror= ).with( 'HTTP://WWW.DEBIAN.OR.JP/DEBIAN/' ).once.ordered
      block.call debootstrap_option_mock
    end

    flexstub( Apt, 'APT' ).should_receive( :new ).with( :clean, Proc ).once.ordered.and_return do | command, block |
      apt_option_mock = flexmock( 'APT_OPTION' )
      apt_option_mock.should_receive( :root= ).with( '/TMP' ).once.ordered
      block.call apt_option_mock
    end

    flexstub( Shell, 'SHELL_CLASS' ).should_receive( :open ).with( Proc ).once.ordered.and_return do | block |
      shell = flexmock( 'SHELL' )
      shell.should_receive( :exec ).with( { 'LC_ALL' => 'C' }, 'rm', '-f', '/TMP/etc/resolv.conf' ).once.ordered
      block.call shell
    end

    # mocking build_installer_base_tarball
    flexstub( Shell, 'SHELL_CLASS' ).should_receive( :open ).with( Proc ).once.ordered.and_return do | block |
      shell = flexmock( 'SHELL' )
      shell.should_receive( :exec ).with( { 'LC_ALL' => 'C' }, 'tar', '--one-file-system', '--directory', '/TMP', '-czvf', '/TMP/DEBIAN_SARGE.tgz', '.' ).once.ordered
      block.call shell
    end

    Rake::InstallerBaseTask.new do | task |
      task.target_directory = '/TMP'
      task.mirror = 'HTTP://WWW.DEBIAN.OR.JP/DEBIAN/'
      task.distribution = 'DEBIAN'
      task.suite = 'SARGE'
    end
    Task[ '/TMP/DEBIAN_SARGE.tgz' ].execute
  end
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
