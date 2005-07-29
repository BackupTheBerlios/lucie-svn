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
  def test_aptitude_string_arg
    aptitude_command = aptitude( "FOO" )
    assert_equal( %{chroot /tmp/target aptitude -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install FOO},
                  aptitude_command.commandline[0], '���ޥ�ɥ饤��ʸ�����������ʤ�' )
  end

  public
  def test_aptitude_array_arg
    aptitude_command = aptitude( ["FOO", "BAR", "BAZ"] )
    assert_equal( %{chroot /tmp/target aptitude -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install FOO BAR BAZ},
                  aptitude_command.commandline[0], '���ޥ�ɥ饤��ʸ�����������ʤ�' )
  end

  public
  def test_commandline_aptitude
    aptitude_command = aptitude do |aptitude|
      aptitude.list << "FOO" << "BAR" << "BAZ"
    end
    assert_equal( %{chroot /tmp/target aptitude -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install FOO BAR BAZ},
                  aptitude_command.commandline[0], '���ޥ�ɥ饤��ʸ�����������ʤ�' )
    assert_equal( %{chroot /tmp/target apt-get clean}, aptitude_command.commandline[1], '���ޥ�ɥ饤��ʸ�����������ʤ�' )
  end

  public
  def test_commandline_preloadrm
    aptitude_command = aptitude do |aptitude|
      aptitude.preloadrm << { :url => %{file:///tmp/FOO.TGZ}, :directory => %{preload} }
      aptitude.list << "FOO" << "BAR" << "BAZ"
    end
    assert_equal( %{rm /tmp/target/preload/FOO.TGZ},
                  aptitude_command.commandline[3], '���ޥ�ɥ饤��ʸ�����������ʤ�' )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
