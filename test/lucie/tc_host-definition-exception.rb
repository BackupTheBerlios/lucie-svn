#
# $Id$
#
# Author::   Yoshiaki Sakae (mailto:sakae@is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'lucie/config'
require 'lucie/config/host'
require 'test/unit'

class TC_HostDefinitionException < Test::Unit::TestCase
  public
  def test_name_exception
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      host do |host|
        host.name = '*'
      end
    end
    
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      host do |host|
        host.name = '?'
      end
    end
  end

  public
  def test_name_nothing_raised
    assert_nothing_raised( '例外が raise された' ) do 
      host do |host|
        host.name = 'aiUeo-kakikukeko_Sasisuseso'
      end
    end
  end
  
# ------------------------------------------------------------------------------
  
  public
  def test_alias_exception
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      host do |host|
        host.alias = ''
      end
    end

    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      host do |host|
        host.alias = "\n"
      end
    end
  end

  public
  def test_alias_nothing_raised
    assert_nothing_raised( '例外が raise された' ) do 
      host do |host|
        host.alias = 'aiueo- bo Y 12_#'
      end
    end
  end
  
# ------------------------------------------------------------------------------

  public
  def test_address_exception
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do
      host do |host|
        host.address = '*'
      end
    end
    
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do
      host do |host|
        host.address = '092.1.2.9'
      end
    end
  end
  
  public
  def test_address_nothing_raised
    assert_nothing_raised( '例外が raise された' ) do
      host do |host|
        host.address = '192.168.0.1'
      end
    end
  end
  
# ------------------------------------------------------------------------------
  
  public
  def test_mac_address_exception
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do
      host do |host|
        host.mac_address = '*'
      end
    end

    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do
      host do |host|
        host.mac_address = '00:50:56:00:32'
      end
    end

    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do
      host do |host|
        host.mac_address = '00:50:56:00:32:7D:88'
      end
    end

    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do
      host do |host|
        host.mac_address = '0H:50:56:00:32:7D'
      end
    end
  end
  
  public
  def test_mac_nothing_raised
    assert_nothing_raised( '例外が raise された' ) do 
      host do |host|
        host.mac_address = '00:0C:29:41:88:F0'
      end
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: