#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'


require 'mock'
require 'debconf/client'
require 'test/unit'


class TC_Client < Test::Unit::TestCase
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


  def test_go
    $stdout_mock = Mock.new( '#<STDOUT (Mock)>' )
    $stdout_mock.__next( :print ) do |command| 
      assert_equal( "GO\n", command, 'request •¶Žš—ñ‚ªˆá‚¤' )
    end
    $stdin_mock = Mock.new( '#<STDIN (Mock)>' )
    $stdin_mock.__next( :gets ) do '0' end    
    Debconf::Client.go
  end


  def test_get
    $stdout_mock = Mock.new( '#<STDOUT (Mock)>' )
    $stdout_mock.__next( :print ) do |command| 
      assert_equal( "GET QUESTION\n", command, 'request •¶Žš—ñ‚ªˆá‚¤' )
    end
    $stdin_mock = Mock.new( '#<STDIN (Mock)>' )
    $stdin_mock.__next( :gets ) do '0' end    
    Debconf::Client.get( 'QUESTION' )
  end


  def test_set
    $stdout_mock = Mock.new( '#<STDOUT (Mock)>' )
    $stdout_mock.__next( :print ) do |command| 
      assert_equal( "SET QUESTION true\n", command, 'request •¶Žš—ñ‚ªˆá‚¤' )
    end
    $stdin_mock = Mock.new( '#<STDIN (Mock)>' )
    $stdin_mock.__next( :gets ) do '0' end    
    Debconf::Client.set( 'QUESTION true' )
  end
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
