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
  # parse_response の返り値を確認
  public
  def test_parse_response
    assert_equal( 'RESPONSE', Debconf::Client.parse_response( '0 RESPONSE' ), 'parse_response の返り値が正しくない')
  end
  
  # 返り値 10-19 で例外 Debconf::Exception::InvalidParametersException の確認
  public
  def test_parse_response_raises_invalid_parameters_exception
    assert_raises( Debconf::Exception::InvalidParametersException, 
                   'Debconf::Exception::InvalidParametersException が raise されなかった' ) do 
      Debconf::Client.parse_response( '10 RESPONSE' ) # 境界条件
    end
    
    assert_raises( Debconf::Exception::InvalidParametersException, 
                   'Debconf::Exception::InvalidParametersException が raise されなかった' ) do 
      Debconf::Client.parse_response( '15 RESPONSE' )
    end
    
    assert_raises( Debconf::Exception::InvalidParametersException, 
                   'Debconf::Exception::InvalidParametersException が raise されなかった' ) do 
      Debconf::Client.parse_response( '19 RESPONSE' ) # 境界条件
    end    
  end
  
  # 返り値 20-29 で 例外 Debconf::Exception::SyntaxError の確認
  public
  def test_parse_response_raises_syntax_error
    assert_raises( Debconf::Error::SyntaxError,
                   'Debconf::Error::SyntaxError が raise されなかった' ) do
      Debconf::Client.parse_response( '20 RESPONSE' ) # 境界条件
    end
    
    assert_raises( Debconf::Error::SyntaxError,
                   'Debconf::Error::SyntaxError が raise されなかった' ) do
      Debconf::Client.parse_response( '25 RESPONSE' )
    end
    
    assert_raises( Debconf::Error::SyntaxError,
                   'Debconf::Error::SyntaxError が raise されなかった' ) do
      Debconf::Client.parse_response( '29 RESPONSE' ) # 境界条件
    end
  end
  
  # 返り値 30-99 で nil が返ることを確認
  public
  def test_parse_response_returns_nil
    assert_nil( Debconf::Client.parse_response( '30 RESPONSE' ), 'nil が返らなかった' ) # 境界条件
    assert_nil( Debconf::Client.parse_response( '35 RESPONSE' ), 'nil が返らなかった' )
    assert_nil( Debconf::Client.parse_response( '99 RESPONSE' ), 'nil が返らなかった' ) # 境界条件
  end
  
  # 返り値 100-109 で 例外 Debconf::Error::InternalError の確認
  public
  def test_parse_response_raises_internal_error
    assert_raises( Debconf::Error::InternalError,
                   'Debconf::Error::InternalError が raise されなかった' ) do
      Debconf::Client.parse_response( '100 RESPONSE' ) # 境界条件
    end
    
    assert_raises( Debconf::Error::InternalError,
                   'Debconf::Error::InternalError が raise されなかった' ) do
      Debconf::Client.parse_response( '105 RESPONSE' )
    end
    
    assert_raises( Debconf::Error::InternalError,
                   'Debconf::Error::InternalError が raise されなかった' ) do
      Debconf::Client.parse_response( '109 RESPONSE' ) # 境界条件
    end
  end
  
  # 返り値 256- で Debconf::Exception::UnknownReturnValueException が返ることを確認
  public
  def test_parse_response_raises_unknown_return_value_exception
    assert_raises( Debconf::Exception::UnknownReturnValueException,
                   'Debconf::Exception::UnknownReturnValueException が raise されなかった' ) do
      Debconf::Client.parse_response( '256 RESPONSE' ) # 境界条件
    end
    
    assert_raises( Debconf::Exception::UnknownReturnValueException,
                   'Debconf::Exception::UnknownReturnValueException が raise されなかった' ) do
      Debconf::Client.parse_response( '266 RESPONSE' )
    end
  end  
  
  # 例外 Debconf::Error::InternalRubyError の確認
  public
  def test_parse_response_raises_internal_ruby_error
    assert_raises( Debconf::Error::InternalRubyError, 'InternalRubyError が raise されなかった' ) do
      Debconf::Client.parse_response( 'RESPONSE' )
    end 
  end
  
  # Debconf の GO コマンドを確認
  public
  def test_go
    $stdout_mock = Mock.new( '#<STDOUT (Mock)>' )
    $stdout_mock.__next( :print ) do |command| 
      assert_equal( "GO\n", command, '発行されたコマンドが正しくない' )
    end
    $stdin_mock = Mock.new( '#<STDIN (Mock)>' )
    $stdin_mock.__next( :gets ) do '0' end    
    Debconf::Client.go
  end
  
  # Debconf の GET コマンドを確認
  public
  def test_get
    $stdout_mock = Mock.new( '#<STDOUT (Mock)>' )
    $stdout_mock.__next( :print ) do |command| 
      assert_equal( "GET QUESTION\n", command, '発行されたコマンドが正しくない' )
    end
    $stdin_mock = Mock.new( '#<STDIN (Mock)>' )
    $stdin_mock.__next( :gets ) do '0' end    
    Debconf::Client.get( 'QUESTION' )
  end

  # Debconf の SET コマンドを確認
  public
  def test_set
    $stdout_mock = Mock.new( '#<STDOUT (Mock)>' )
    $stdout_mock.__next( :print ) do |command| 
      assert_equal( "SET QUESTION true\n", command, '発行されたコマンドが正しくない' )
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