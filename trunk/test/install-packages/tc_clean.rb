#
# $Id: tc_abstract-template.rb 645 2005-06-01 07:08:14Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 645 $
# License::  GPL2

$LOAD_PATH.unshift './bin'

require 'install-packages'
require 'test/unit'

class TC_Clean < Test::Unit::TestCase
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
