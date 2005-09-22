#
# $Id: tc_host-definition-exception.rb 451 2005-03-25 08:50:01Z takamiya $
#
# Author::   Yoshiaki Sakae (mailto:sakae@is.titech.ac.jp)
# Revision:: $LastChangedRevision: 451 $
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'lucie/config'
require 'lucie/config/package-server'
require 'test/unit'

class TC_PackageServerDefinitionException < Test::Unit::TestCase
  public
  def test_name_exception
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      package_server do |package_server|
        package_server.name = '*'
      end
    end
    
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      package_server do |package_server|
        package_server.name = '?'
      end
    end
  end

  public
  def test_name_nothing_raised
    assert_nothing_raised( '例外が raise された' ) do 
      package_server do |package_server|
        package_server.name = 'aiUeo-kakikukeko_Sasisuseso'
      end
    end
  end
  
# ------------------------------------------------------------------------------
  
  public
  def test_alias_exception
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      package_server do |package_server|
        package_server.alias = ''
      end
    end

    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      package_server do |package_server|
        package_server.alias = "\n"
      end
    end
  end

  public
  def test_alias_nothing_raised
    assert_nothing_raised( '例外が raise された' ) do 
      package_server do |package_server|
        package_server.alias = 'aiueo- bo Y 12_#'
      end
    end
  end
  
# ------------------------------------------------------------------------------
  
  public
  def test_uri_exception
    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      package_server do |package_server|
        package_server.uri = '\n'
      end
    end

    assert_raises( Lucie::Config::InvalidAttributeException,
                   '例外が raise されなかった' ) do 
      package_server do |package_server|
        package_server.uri = '192.168.1.100/debian'
      end
    end
  end

  public
  def test_uri_nothing_raised
    assert_nothing_raised( '例外が raise された' ) do 
      package_server do |package_server|
        package_server.uri = 'http://192.168.1.100/debian/'
      end
    end

    assert_nothing_raised( '例外が raise された' ) do 
      package_server do |package_server|
        package_server.uri = 'ftp://192.168.1.100/debian/'
      end
    end

    assert_nothing_raised( '例外が raise された' ) do 
      package_server do |package_server|
        package_server.uri = 'http://lucie.example.com/debian/'
      end
    end
  end

end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
