#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'lucie/config/dhcp-server'

class TC_DHCPServerDefinition < Test::Unit::TestCase
  public
  def teardown
    Lucie::Config::DHCPServer.clear
  end
  
  public
  def test_accessor
    dhcp_server = Lucie::Config::DHCPServer.new do |dhcp_server|
      dhcp_server.name            = 'dhcp'
      dhcp_server.alias          = 'Cluster DHCP Server'
      dhcp_server.nis_domain_name = 'yp.titech.ac.jp'
      dhcp_server.gateway         = '192.168.1.254'
      dhcp_server.address         = '192.168.1.200'
      dhcp_server.subnet          = '255.255.255.0'
      dhcp_server.dns             = '131.112.35.1'
      dhcp_server.domain_name     = 'is.titech.ac.jp'
    end
    
    assert_equal( 'dhcp', dhcp_server.name )
    assert_equal( 'Cluster DHCP Server', dhcp_server.alias )
    assert_equal( 'yp.titech.ac.jp', dhcp_server.nis_domain_name )
    assert_equal( '192.168.1.254', dhcp_server.gateway )
    assert_equal( '192.168.1.200', dhcp_server.address )
    assert_equal( '255.255.255.0', dhcp_server.subnet )
    assert_equal( '131.112.35.1', dhcp_server.dns )
    assert_equal( 'is.titech.ac.jp', dhcp_server.domain_name )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: