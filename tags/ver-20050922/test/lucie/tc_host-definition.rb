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
  def setup
    @host = Lucie::Config::Host.new do |host|
      host.name = 'cluster_node00'
      host.alias = 'Cluster Node #00'
      host.address = '192.168.0.1'
      host.mac_address = '00:0C:29:41:88:FD'
    end
  end
  
  public
  def teardown
    Lucie::Config::Host.clear
  end
  
  public
  def test_accessor 
    assert_equal( 'cluster_node00', @host.name )
    assert_equal( 'Cluster Node #00', @host.alias )
    assert_equal( '192.168.0.1', @host.address )
    assert_equal( '00:0C:29:41:88:FD', @host.mac_address )
  end
  
  public
  def test_inspect
    assert_match( /@address=\"192\.168\.0\.1\"/, @host.inspect )
    assert_match( /@alias=\"Cluster Node #00\"/, @host.inspect )
    assert_match( /@mac_address=\"00:0C:29:41:88:FD\"/, @host.inspect )
    assert_match( /@name=\"cluster_node00\"/, @host.inspect )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
