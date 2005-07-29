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
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
