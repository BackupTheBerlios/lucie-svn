#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'lucie/config/host-group'
require 'test/unit'

class TC_HostGroupDefinition < Test::Unit::TestCase
  public
  def test_accessor
    group = Lucie::Config::HostGroup.new do |group|
      group.name = 'presto_cluster'
      group.alias = 'Presto Cluster'
      group.members = ['cluster_node00', 'cluster_node01']    
    end
    
    assert_equal( 'presto_cluster', group.name )
    assert_equal( 'Presto Cluster', group.alias )
    assert_equal( ['cluster_node00', 'cluster_node01'], group.members )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: