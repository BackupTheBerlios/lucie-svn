#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './bin'

require 'install-packages'
require 'test/unit'

class TC_Clean < Test::Unit::TestCase
  public
  def test_clean
    clean
  end

  public
  def test_commandline
    clean = InstallPackages::Command::Clean.new( nil )
    assert_equal( 'chroot /tmp/target apt-get clean', clean.commandline, 'コマンドライン文字列が正しくない' )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
