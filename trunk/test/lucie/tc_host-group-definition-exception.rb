#
# $Id: tc_host-definition-exception.rb 451 2005-03-25 08:50:01Z takamiya $
#
# Author::   Yoshiaki Sakae (mailto:sakae@is.titech.ac.jp)
# Revision:: $LastChangedRevision: 451 $
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'lucie/config'
require 'lucie/config/host-group'
require 'test/unit'
include Lucie::Config

class TC_HostGroupDefinitionException < Test::Unit::TestCase
  public
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
    Host.clear
  end

# ------------------------------------------------------------------------------

  public
  def test_name_exception
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      host_group do |host_group|
        host_group.name = '*'
      end
    end
    
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      host_group do |host_group|
        host_group.name = '?'
      end
    end
  end

  public
  def test_name_nothing_raised
    assert_nothing_raised( '例外が raise された' ) do 
      host_group do |host_group|
        host_group.name = 'aiUeo-kakikukeko_Sasisuseso'
      end
    end
  end

# ------------------------------------------------------------------------------
  
  public
  def test_alias_exception
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      host_group do |host_group|
        host_group.alias = ''
      end
    end

    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      host_group do |host_group|
        host_group.alias = "\n"
      end
    end
  end

  public
  def test_alias_nothing_raised
    assert_nothing_raised( '例外が raise された' ) do 
      host_group do |host_group|
        host_group.alias = 'aiueo- bo Y 12_'
      end
    end
  end

# ------------------------------------------------------------------------------
  
  public
  def test_members_exception
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      host_group do |host_group|
        host_group.members = '\n'
      end
    end
  end

  public
  def test_members_exception
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      host_group do |host_group|
        host_group.members = Object.new
      end
    end
  end

  public
  def test_members_nothing_raised
    assert_nothing_raised( '例外が raise された' ) do 
      host_group do |host_group|
        host_group.members = [Host['cluster_node00']]
      end
    end

    assert_nothing_raised( '例外が raise された' ) do 
      host_group do |host_group|
        host_group.members = [Host['cluster_node00'], Host['cluster_node01']]
      end
    end
   end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: