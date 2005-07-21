#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './bin'

require 'install-packages'
require 'test/unit'

class TC_Taskinst < Test::Unit::TestCase
  public
  def test_commandline
    taskinst = InstallPackages::Command::Taskinst.new( { 'taskinst' => ['FOO', 'BAR', 'BAZ'] } )
    assert_equal( 'chroot /tmp/target tasksel -n install FOO', 
                  taskinst.commandline[0],
                  'コマンドライン文字列が正しくない' )
    assert_equal( 'chroot /tmp/target tasksel -n install BAR', 
                  taskinst.commandline[1],
                  'コマンドライン文字列が正しくない' )
    assert_equal( 'chroot /tmp/target tasksel -n install BAZ', 
                  taskinst.commandline[2],
                  'コマンドライン文字列が正しくない' )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
