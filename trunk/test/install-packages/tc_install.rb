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
  def test_install_string_arg
    install_command = install( "FOO" )
    assert_equal( %{chroot /tmp/target apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" --force-yes --fix-missing install FOO},
                  install_command.commandline[0], 'コマンドライン文字列が正しくない' )
  end

  public
  def test_install_string_arg
    install_command = install( ["FOO", "BAR", "BAZ"] )
    assert_equal( %{chroot /tmp/target apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" --force-yes --fix-missing install FOO BAR BAZ},
                  install_command.commandline[0], 'コマンドライン文字列が正しくない' )
  end

  public
  def test_commandline_aptget
    install_command = install do |install|
      install.preload << { :url => %{http://foo.bar/baz.tgz}, :directory => %{preload} }
      install.list << "FOO" << "BAR" << "BAZ"
    end
    assert_equal( %{chroot /tmp/target apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" --force-yes --fix-missing install FOO BAR BAZ},
                  install_command.commandline[1], 'コマンドライン文字列が正しくない' )
    assert_equal( %{chroot /tmp/target apt-get clean}, 
                  install_command.commandline[2], 'コマンドライン文字列が正しくない' )
  end
  
  public
  def test_commandline_wget
    install_command = install do |install|
      install.preload << { :url => %{http://foo.bar/baz.tgz}, :directory => %{preload} }
      install.list << "FOO" << "BAR" << "BAZ"
    end
    assert_equal( %{wget -nv -P/tmp/target/preload http://foo.bar/baz.tgz},
                  install_command.commandline[0], 'コマンドライン文字列が正しくない' )
  end
  
  public
  def test_commandline_cp
    install_command = install do |install|
      install.preload << { :url => %{file:///tmp/FOO.TGZ}, :directory => %{preload} }
      install.list << "FOO" << "BAR" << "BAZ"
    end
    assert_equal( %{cp /etc/lucie//tmp/FOO.TGZ /tmp/target/preload},
                  install_command.commandline[0], 'コマンドライン文字列が正しくない' )
  end

  public
  def test_commandline_preloadrm
    install_command = install do |install|
      install.preloadrm << { :url => %{file:///tmp/FOO.TGZ}, :directory => %{preload} }
      install.list << "FOO" << "BAR" << "BAZ"
    end
    assert_equal( %{rm /tmp/target/preload/FOO.TGZ}, install_command.commandline[3],
                  'コマンドライン文字列が正しくない' )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
