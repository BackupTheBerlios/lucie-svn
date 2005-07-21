#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './bin'

require 'install-packages'
require 'test/unit'

class TC_DselectUpgrade < Test::Unit::TestCase
  public
  def test_commandline
    $dry_run = true
    dselect_upgrade = InstallPackages::Command::DselectUpgrade.new( { 'dselect-upgrade' =>
                                                                        [{ :package => 'aalib1',
                                                                          :action  => 'install' },
                                                                        { :package => 'kvim',
                                                                          :action  => 'deinstall' }] } )
    assert_equal( %{chroot /tmp/target dpkg --set-selections < /tmp/target/tmp/dpkg-selections.tmp},
                  dselect_upgrade.commandline[0],
                  'コマンドライン文字列が正しくない' )
    assert_equal( %{chroot /tmp/target apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dselect-upgrade}, dselect_upgrade.commandline[1],
                  'コマンドライン文字列が正しくない' )
    assert_equal( %{rm /tmp/target/tmp/dpkg-selections.tmp},
                  dselect_upgrade.commandline[2],
                  'コマンドライン文字列が正しくない' )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
