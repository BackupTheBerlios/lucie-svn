#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'lucie/config'
require 'lucie/config/host-group'
require 'test/unit'
include Lucie::Config

class TC_HostGroupDefinition < Test::Unit::TestCase
  def setup
    host do |host|
      host.name = 'cluster_node00'
      host.alias = 'Cluster Node #00'
      host.address = '192.168.0.1'
      host.mac_address = '00:0C:29:41:88:FD'
    end
    
    host do |host|
      host.name = 'cluster_node01'
      host.alias = 'Cluster Node #01'
      host.address = '192.168.0.2'
      host.mac_address = '00:0C:29:41:88:FE'
    end
  end

  public
  def teardown
    Lucie::Config::HostGroup.clear
  end
  
  public
  def test_accessor
    group = Lucie::Config::HostGroup.new do |group|
      group.name = 'presto_cluster'
      group.alias = 'Presto Cluster'
      group.members = [Host['cluster_node00'], Host['cluster_node01']]    
    end
    
    assert_equal( 'presto_cluster', group.name )
    assert_equal( 'Presto Cluster', group.alias )
    assert_equal( [Host['cluster_node00'], Host['cluster_node01']], group.members )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: