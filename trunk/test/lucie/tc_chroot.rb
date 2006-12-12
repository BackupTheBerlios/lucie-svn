#
# $Id$
#
# Author:: Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License:: GPL2


$LOAD_PATH.unshift './lib'


require 'lucie/chroot'
require 'flexmock'
require 'test/unit'


class TC_Chroot < Test::Unit::TestCase
  include FlexMock::TestCase


  def test_new
    shell_mock = flexmock( 'SHELL_MOCK' )
    shell_mock.should_receive( :on_stdout ).once.ordered
    shell_mock.should_receive( :on_stderr ).once.ordered
    shell_mock.should_receive( :on_success ).once.ordered
    shell_mock.should_receive( :on_failure ).once.ordered
    shell_mock.should_receive( :exec ).with( { 'LC_ALL' => 'C' }, 'chroot', '/ROOT', 'apt-get', 'clean' ).once.ordered
    shell_mock.should_receive( :child_status ).once.ordered.and_return( 'CHILD_STATUS' )
    flexstub( Shell, 'SHELL' ).should_receive( :new ).once.ordered.and_return( shell_mock )

    chroot_shell = ChrootShell.open do | shell |
      shell.root = '/ROOT'
      shell.on_stdout do end
      shell.on_stderr do end
      shell.on_success do end
      shell.on_failure do end
      shell.exec( { 'LC_ALL' => 'C' }, 'apt-get', 'clean' )
    end

    assert_equal 'CHILD_STATUS', chroot_shell.child_status
  end
end

