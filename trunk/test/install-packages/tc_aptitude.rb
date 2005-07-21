#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './bin'

require 'install-packages'
require 'test/unit'

class TC_Aptitude < Test::Unit::TestCase
  public
  def test_commandline
    aptitude = InstallPackages::Command::Aptitude.new( { 'aptitude' => ['FOO', 'BAR', 'BAZ'] } )
    assert_equal( %{chroot /tmp/target aptitude -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install FOO BAR BAZ},
                  aptitude.commandline[0], 'コマンドライン文字列が正しくない' )
    assert_equal( %{chroot /tmp/target apt-get clean}, aptitude.commandline[1], 'コマンドライン文字列が正しくない' )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
