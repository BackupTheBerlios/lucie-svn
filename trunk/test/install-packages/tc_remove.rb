#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './bin'

require 'install-packages'
require 'test/unit'

class TC_Remove < Test::Unit::TestCase
  public
  def test_remove_stringarg
    remove_command = remove( "FOO" )
    assert_equal( 'chroot /tmp/target apt-get --purge remove FOO',
                  remove_command.commandline, 'コマンドライン文字列が正しくない' )
  end

  public
  def test_remove
    remove_command = remove( ["FOO", "BAR", "BAZ"] )
    assert_equal( 'chroot /tmp/target apt-get --purge remove FOO BAR BAZ',
                  remove_command.commandline, 'コマンドライン文字列が正しくない' )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
