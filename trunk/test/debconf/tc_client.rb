#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:yasuhito@gmail.com)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'


require 'rubygems'
require 'flexmock'
require 'stringio'
require 'debconf/client'
require 'test/unit'


class TC_Client < Test::Unit::TestCase
  include FlexMock::TestCase


  def test_parse_response_code_0
    assert_equal( 'RESPONSE', Debconf::Client.parse_response( '0 RESPONSE' ) )
  end


  def test_parse_response_code_10_19
    ( 10..19 ).each do | each |
      assert_raises( Debconf::Exception::InvalidParametersException ) do
        Debconf::Client.parse_response( "#{ each } ERROR MESSAGE" )
      end
    end
  end


  def test_parse_response_code_20_29
    ( 20..29 ).each do | each |
      assert_raises( Debconf::Error::SyntaxError ) do
        Debconf::Client.parse_response( "#{ each } ERROR MESSAGE" )
      end
    end
  end


  def test_parse_response_code_30_99
    ( 30..99 ).each do | each |
      assert_equal( each, Debconf::Client.parse_response( "#{ each } RESPONSE" ) )
    end
  end


  def test_parse_response_code_100_109
    ( 100..109 ).each do | each |
      assert_raises( Debconf::Error::InternalError ) do
        Debconf::Client.parse_response( "#{ each } ERROR MESSAGE" )
      end
    end
  end


  def test_parse_response_code_unknown
    ( 110..200 ).each do | each |
      assert_raises( Debconf::Exception::UnknownReturnValueException ) do
        Debconf::Client.parse_response( "#{ each } ERROR MESSAGE" )
      end
    end
  end


  def test_parse_response_internal_ruby_error
    assert_raises( Debconf::Error::InternalRubyError ) do
      Debconf::Client.parse_response( "CANNOT PARSE (CAUSES INTERNAL RUBY ERROR)" )
    end
  end


  # Tests for debconf commands #################################################


  # [TODO] test other debconf commands (capb, title, ... )


  def test_go
    stdout = flexmock( 'stdout' )
    Debconf::Client.load_stdin StringIO.new( '0 OK' )
    Debconf::Client.load_stdout stdout
    stdout.should_receive( :puts ).with( 'GO' ).once.ordered

    assert_equal 'OK', Debconf::Client.go
  end


  def test_get
    stdout = flexmock( 'stdout' )
    Debconf::Client.load_stdin StringIO.new( '0 OK' )
    Debconf::Client.load_stdout stdout
    stdout.should_receive( :puts ).with( 'GET FOOBAR' ).once.ordered

    assert_equal 'OK', Debconf::Client.get( 'FOOBAR' )
  end


  def test_set
    stdout = flexmock( 'stdout' )
    Debconf::Client.load_stdin StringIO.new( '0 OK' )
    Debconf::Client.load_stdout stdout
    stdout.should_receive( :puts ).with( 'SET FOOBAR true' ).once.ordered

    assert_equal 'OK', Debconf::Client.set( 'FOOBAR true' )
  end
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
