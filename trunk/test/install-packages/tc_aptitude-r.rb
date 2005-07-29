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
  def test_commandline_arg_string
    aptitude_r_command = aptitude_r( "FOO" )
    assert_equal( %{chroot /tmp/target aptitude -r -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install FOO},
                  aptitude_r_command.commandline[0], 'コマンドライン文字列が正しくない' )
  end

  public
  def test_commandline_arg_array
    aptitude_r_command = aptitude_r( ["FOO", "BAR", "BAZ"] )
    assert_equal( %{chroot /tmp/target aptitude -r -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install FOO BAR BAZ},
                  aptitude_r_command.commandline[0], 'コマンドライン文字列が正しくない' )
  end

  public
  def test_commandline_aptitude
    aptitude_r_command = aptitude_r do |aptitude_r|
      aptitude_r.list << "FOO" << "BAR" << "BAZ"
    end
    assert_equal( %{chroot /tmp/target aptitude -r -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install FOO BAR BAZ},
                  aptitude_r_command.commandline[0], 'コマンドライン文字列が正しくない' )
  end

  public
  def test_commandline_wget
    aptitude_r_command = aptitude_r do |aptitude_r|
      aptitude_r.preload << { :url => %{http://foo.bar/baz.tgz}, :directory => %{preload} }
      aptitude_r.list << "FOO" << "BAR" << "BAZ"
    end
    assert_equal( %{wget -nv -P/tmp/target/preload http://foo.bar/baz.tgz},
                  aptitude_r_command.commandline[0], 'コマンドライン文字列が正しくない' )
  end

  public
  def test_commandline_cp
    aptitude_r_command = aptitude_r do |aptitude_r|
      aptitude_r.preload << { :url => %{file:///tmp/FOO.TGZ}, :directory => %{preload} }
      aptitude_r.list << "FOO" << "BAR" << "BAZ"
    end
    assert_equal( %{cp /etc/lucie//tmp/FOO.TGZ /tmp/target/preload},
                  aptitude_r_command.commandline[0], 'コマンドライン文字列が正しくない' )
  end

  public
  def test_commandline_preloadrm
    aptitude_r_command = aptitude_r do |aptitude_r|
      aptitude_r.preloadrm << { :url => %{file:///tmp/FOO.TGZ}, :directory => %{preload} }
      aptitude_r.list << "FOO" << "BAR" << "BAZ"
    end
    assert_equal( %{rm /tmp/target/preload/FOO.TGZ},
                  aptitude_r_command.commandline[2], 'コマンドライン文字列が正しくない' )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
