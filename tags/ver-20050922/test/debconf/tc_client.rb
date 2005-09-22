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
  public
  def test_parse_response
    assert_equal( 'RESPONSE', Debconf::Client.parse_response( '0 RESPONSE' ),
                  'parse_response の返り値が違う')
    assert_equal( 30, Debconf::Client.parse_response( '30 RESPONSE' ),
                  'parse_response の返り値が違う' )
    assert_equal( 35, Debconf::Client.parse_response( '35 RESPONSE' ),
                  'parse_response の返り値が違う' )
    assert_equal( 99, Debconf::Client.parse_response( '99 RESPONSE' ), 
                  'parse_response の返り値が違う' )
  end
  
  public
  def test_go
    $stdout_mock = Mock.new( '#<STDOUT (Mock)>' )
    $stdout_mock.__next( :print ) do |command| 
      assert_equal( "GO\n", command, 'request 文字列が違う' )
    end
    $stdin_mock = Mock.new( '#<STDIN (Mock)>' )
    $stdin_mock.__next( :gets ) do '0' end    
    Debconf::Client.go
  end
  
  public
  def test_get
    $stdout_mock = Mock.new( '#<STDOUT (Mock)>' )
    $stdout_mock.__next( :print ) do |command| 
      assert_equal( "GET QUESTION\n", command, 'request 文字列が違う' )
    end
    $stdin_mock = Mock.new( '#<STDIN (Mock)>' )
    $stdin_mock.__next( :gets ) do '0' end    
    Debconf::Client.get( 'QUESTION' )
  end
  
  public
  def test_set
    $stdout_mock = Mock.new( '#<STDOUT (Mock)>' )
    $stdout_mock.__next( :print ) do |command| 
      assert_equal( "SET QUESTION true\n", command, 'request 文字列が違う' )
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