#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './bin'

require 'install-packages'
require 'test/unit'

class TC_Install < Test::Unit::TestCase
  public
  def test_install_string_arg
    install_command = install( "FOO" )
    assert_equal( %{chroot /tmp/target apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" --force-yes --fix-missing install FOO},
                  install_command.commandline[0], '���ޥ�ɥ饤��ʸ�����������ʤ�' )
  end

  public
  def test_install_string_arg
    install_command = install( ["FOO", "BAR", "BAZ"] )
    assert_equal( %{chroot /tmp/target apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" --force-yes --fix-missing install FOO BAR BAZ},
                  install_command.commandline[0], '���ޥ�ɥ饤��ʸ�����������ʤ�' )
  end

  public
  def test_commandline_aptget
    install_command = install do |install|
      install.preload << { :url => %{http://foo.bar/baz.tgz}, :directory => %{preload} }
      install.list << "FOO" << "BAR" << "BAZ"
    end
    assert_equal( %{chroot /tmp/target apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" --force-yes --fix-missing install FOO BAR BAZ},
                  install_command.commandline[1], '���ޥ�ɥ饤��ʸ�����������ʤ�' )
    assert_equal( %{chroot /tmp/target apt-get clean}, 
                  install_command.commandline[2], '���ޥ�ɥ饤��ʸ�����������ʤ�' )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
