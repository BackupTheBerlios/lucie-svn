#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './bin'

require 'install-packages'
require 'test/unit'

class TC_Hold < Test::Unit::TestCase
  public
  def test_hold_string_arg
    hold_command = hold( 'FOO' )
    assert_equal( 'echo FOO hold | chroot /tmp/target dpkg --set-selections',
                  hold_command.commandline[0], 'コマンドライン文字列が正しくない' )
  end

  public
  def test_hold
    hold_command = hold( ['FOO', 'BAR', 'BAZ'] )
    assert_equal( 'echo FOO hold | chroot /tmp/target dpkg --set-selections',
                  hold_command.commandline[0], 'コマンドライン文字列が正しくない' )
    assert_equal( 'echo BAR hold | chroot /tmp/target dpkg --set-selections',
                  hold_command.commandline[1], 'コマンドライン文字列が正しくない' )
    assert_equal( 'echo BAZ hold | chroot /tmp/target dpkg --set-selections',
                  hold_command.commandline[2], 'コマンドライン文字列が正しくない' )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
