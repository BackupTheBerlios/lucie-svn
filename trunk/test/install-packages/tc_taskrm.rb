#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './bin'

require 'install-packages'
require 'test/unit'

class TC_Taskrm < Test::Unit::TestCase
  public
  def test_taskrm
    taskrm ["foo", "bar", "baz"]
  end

  public
  def test_commandline
    taskrm = InstallPackages::Command::Taskrm.new( ['FOO', 'BAR', 'BAZ'] )
    assert_equal( 'chroot /tmp/target tasksel -n remove FOO', 
                  taskrm.commandline[0],
                  'コマンドライン文字列が正しくない' )
    assert_equal( 'chroot /tmp/target tasksel -n remove BAR', 
                  taskrm.commandline[1],
                  'コマンドライン文字列が正しくない' )
    assert_equal( 'chroot /tmp/target tasksel -n remove BAZ', 
                  taskrm.commandline[2],
                  'コマンドライン文字列が正しくない' )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
