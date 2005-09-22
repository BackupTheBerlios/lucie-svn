#
# $Id: tc_host-definition-exception.rb 451 2005-03-25 08:50:01Z takamiya $
#
# Author::   Yoshiaki Sakae (mailto:sakae@is.titech.ac.jp)
# Revision:: $LastChangedRevision: 451 $
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'lucie/config'
require 'lucie/config/dhcp-server'
require 'test/unit'

class TC_DHCPServertDefinitionException < Test::Unit::TestCase
  public
  def test_name_exception
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      dhcp_server do |dhcp_server|
        dhcp_server.name = '*'
      end
    end
    
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      dhcp_server do |dhcp_server|
        dhcp_server.name = '?'
      end
    end
  end

  public
  def test_name_nothing_raised
    assert_nothing_raised( '例外が raise された' ) do 
      dhcp_server do |dhcp_server|
        dhcp_server.name = 'dhcp'
      end
    end
  end

# ------------------------------------------------------------------------------
  
  public
  def test_alias_exception
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      dhcp_server do |dhcp_server|
        dhcp_server.alias = ''
      end
    end

    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      dhcp_server do |dhcp_server|
        dhcp_server.alias = "\n"
      end
    end
  end

  public
  def test_alias_nothing_raised
    assert_nothing_raised( '例外が raise された' ) do 
      dhcp_server do |dhcp_server|
        dhcp_server.alias = 'aiueo- bo Y 12_#'
      end
    end
  end
  
# ------------------------------------------------------------------------------
  
  public
  def test_nis_domain_name_exception
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      dhcp_server do |dhcp_server|
        dhcp_server.nis_domain_name = '\n'
      end
    end
  end

  public
  def test_nis_domain_name_nothing_raised
    assert_nothing_raised( '例外が raise された' ) do 
      dhcp_server do |dhcp_server|
        dhcp_server.nis_domain_name = 'example'
      end
    end

    assert_nothing_raised( '例外が raise された' ) do 
      dhcp_server do |dhcp_server|
        dhcp_server.nis_domain_name = 'example-10.example.com'
      end
    end
  end

# ------------------------------------------------------------------------------

  public
  def test_gateway_exception
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      dhcp_server do |dhcp_server|
        dhcp_server.gateway = '*'
      end
    end
    
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      dhcp_server do |dhcp_server|
        dhcp_server.gateway = '092.1.2.9'
      end
    end
  end
  
  public
  def test_gateway_nothing_raised
    assert_nothing_raised( '例外が raise された' ) do 
      dhcp_server do |dhcp_server|
        dhcp_server.gateway = '192.168.0.1'
      end
    end
  end

# ------------------------------------------------------------------------------

  public
  def test_address_exception
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      dhcp_server do |dhcp_server|
        dhcp_server.address = '*'
      end
    end
    
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      dhcp_server do |dhcp_server|
        dhcp_server.address = '092.1.2.9'
      end
    end
  end
  
  public
  def test_address_nothing_raised
    assert_nothing_raised( '例外が raise された' ) do 
      dhcp_server do |dhcp_server|
        dhcp_server.address = '192.168.0.1'
      end
    end
  end

# ------------------------------------------------------------------------------

  public
  def test_subnet_exception
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      dhcp_server do |dhcp_server|
        dhcp_server.subnet = '*'
      end
    end
    
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      dhcp_server do |dhcp_server|
        dhcp_server.subnet = '092.1.2.9'
      end
    end
  end
  
  public
  def test_subnet_nothing_raised
    assert_nothing_raised( '例外が raise された' ) do 
      dhcp_server do |dhcp_server|
        dhcp_server.subnet = '192.168.0.1'
      end
    end
  end

# ------------------------------------------------------------------------------

  public
  def test_dns_exception
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      dhcp_server do |dhcp_server|
        dhcp_server.dns = '*'
      end
    end
    
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      dhcp_server do |dhcp_server|
        dhcp_server.dns = '092.1.2.9'
      end
    end
  end
  
  public
  def test_dns_nothing_raised
    assert_nothing_raised( '例外が raise された' ) do 
      dhcp_server do |dhcp_server|
        dhcp_server.dns = '192.168.0.1'
      end
    end
  end

# ------------------------------------------------------------------------------
  
  public
  def test_domain_name_exception
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      dhcp_server do |dhcp_server|
        dhcp_server.domain_name = '\n'
      end
    end
  end

  public
  def test_domain_name_nothing_raised
    assert_nothing_raised( '例外が raise された' ) do 
      dhcp_server do |dhcp_server|
        dhcp_server.domain_name = 'example'
      end
    end

    assert_nothing_raised( '例外が raise された' ) do 
      dhcp_server do |dhcp_server|
        dhcp_server.domain_name = 'example-10.example.com'
      end
    end
  end


end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
