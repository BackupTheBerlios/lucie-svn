#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'lucie/config/host'
require 'test/unit'

class TC_HostDefinition < Test::Unit::TestCase
  public
  def test_accessor
    host = Lucie::Config::Host.new do |host|
      host.name = 'NAME'
      host.alias = 'ALIAS'
      host.address = 'ADDRESS'
      host.mac_address = 'MAC ADDRESS'
    end
    
    assert_equal( 'NAME', host.name )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: