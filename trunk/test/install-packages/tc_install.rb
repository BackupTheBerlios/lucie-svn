#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './bin'

require 'install-packages'
require 'test/unit'

class TC_Install < Test::Unit::TestCase
  public
  def test_install
    install do |install|
      install.list << "initrd-tools" << "lilo"
    end
  end

  public
  def test_commandline
    install = InstallPackages::Command::Install.new( ['FOO', 'BAR', 'BAZ'] )
    assert_equal( %{chroot /tmp/target apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" --force-yes --fix-missing install FOO BAR BAZ},
                  install.commandline[0], '���ޥ�ɥ饤��ʸ�����������ʤ�' )
    assert_equal( %{chroot /tmp/target apt-get clean}, 
                  install.commandline[1], '���ޥ�ɥ饤��ʸ�����������ʤ�' )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
