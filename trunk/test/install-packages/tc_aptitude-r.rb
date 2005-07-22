#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './bin'

require 'install-packages'
require 'test/unit'

class TC_AptitudeR < Test::Unit::TestCase
  public
  def test_commandline
    aptitude_r = InstallPackages::Command::AptitudeR.new( { 'aptitude-r' => ['FOO', 'BAR', 'BAZ'] } )
    assert_equal( %{chroot /tmp/target aptitude -r -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install FOO BAR BAZ},
                  aptitude_r.commandline, 'コマンドライン文字列が正しくない' )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
