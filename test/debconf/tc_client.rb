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
  # parse_response �̕Ԃ�l���m�F
  public
  def test_parse_response
    assert_equal( 'RESPONSE', Debconf::Client.parse_response( '0 RESPONSE' ), 'parse_response �̕Ԃ�l���������Ȃ�')
  end
  
  # �Ԃ�l 10-19 �ŗ�O Debconf::Exception::InvalidParametersException �̊m�F
  public
  def test_parse_response_raises_invalid_parameters_exception
    assert_raises( Debconf::Exception::InvalidParametersException, 
                   'Debconf::Exception::InvalidParametersException �� raise ����Ȃ�����' ) do 
      Debconf::Client.parse_response( '10 RESPONSE' ) # ���E����
    end
    
    assert_raises( Debconf::Exception::InvalidParametersException, 
                   'Debconf::Exception::InvalidParametersException �� raise ����Ȃ�����' ) do 
      Debconf::Client.parse_response( '15 RESPONSE' )
    end
    
    assert_raises( Debconf::Exception::InvalidParametersException, 
                   'Debconf::Exception::InvalidParametersException �� raise ����Ȃ�����' ) do 
      Debconf::Client.parse_response( '19 RESPONSE' ) # ���E����
    end    
  end
  
  # �Ԃ�l 20-29 �� ��O Debconf::Exception::SyntaxError �̊m�F
  public
  def test_parse_response_raises_syntax_error
    assert_raises( Debconf::Error::SyntaxError,
                   'Debconf::Error::SyntaxError �� raise ����Ȃ�����' ) do
      Debconf::Client.parse_response( '20 RESPONSE' ) # ���E����
    end
    
    assert_raises( Debconf::Error::SyntaxError,
                   'Debconf::Error::SyntaxError �� raise ����Ȃ�����' ) do
      Debconf::Client.parse_response( '25 RESPONSE' )
    end
    
    assert_raises( Debconf::Error::SyntaxError,
                   'Debconf::Error::SyntaxError �� raise ����Ȃ�����' ) do
      Debconf::Client.parse_response( '29 RESPONSE' ) # ���E����
    end
  end
  
  # �Ԃ�l 30-99 �� nil ���Ԃ邱�Ƃ��m�F
  public
  def test_parse_response_returns_nil
    assert_nil( Debconf::Client.parse_response( '30 RESPONSE' ), 'nil ���Ԃ�Ȃ�����' ) # ���E����
    assert_nil( Debconf::Client.parse_response( '35 RESPONSE' ), 'nil ���Ԃ�Ȃ�����' )
    assert_nil( Debconf::Client.parse_response( '99 RESPONSE' ), 'nil ���Ԃ�Ȃ�����' ) # ���E����
  end
  
  # �Ԃ�l 100-109 �� ��O Debconf::Error::InternalError �̊m�F
  public
  def test_parse_response_raises_internal_error
    assert_raises( Debconf::Error::InternalError,
                   'Debconf::Error::InternalError �� raise ����Ȃ�����' ) do
      Debconf::Client.parse_response( '100 RESPONSE' ) # ���E����
    end
    
    assert_raises( Debconf::Error::InternalError,
                   'Debconf::Error::InternalError �� raise ����Ȃ�����' ) do
      Debconf::Client.parse_response( '105 RESPONSE' )
    end
    
    assert_raises( Debconf::Error::InternalError,
                   'Debconf::Error::InternalError �� raise ����Ȃ�����' ) do
      Debconf::Client.parse_response( '109 RESPONSE' ) # ���E����
    end
  end
  
  # �Ԃ�l 256- �� Debconf::Exception::UnknownReturnValueException ���Ԃ邱�Ƃ��m�F
  public
  def test_parse_response_raises_unknown_return_value_exception
    assert_raises( Debconf::Exception::UnknownReturnValueException,
                   'Debconf::Exception::UnknownReturnValueException �� raise ����Ȃ�����' ) do
      Debconf::Client.parse_response( '256 RESPONSE' ) # ���E����
    end
    
    assert_raises( Debconf::Exception::UnknownReturnValueException,
                   'Debconf::Exception::UnknownReturnValueException �� raise ����Ȃ�����' ) do
      Debconf::Client.parse_response( '266 RESPONSE' )
    end
  end  
  
  # ��O Debconf::Error::InternalRubyError �̊m�F
  public
  def test_parse_response_raises_internal_ruby_error
    assert_raises( Debconf::Error::InternalRubyError, 'InternalRubyError �� raise ����Ȃ�����' ) do
      Debconf::Client.parse_response( 'RESPONSE' )
    end 
  end
  
  # Debconf �� GO �R�}���h���m�F
  public
  def test_go
    $stdout_mock = Mock.new( '#<STDOUT (Mock)>' )
    $stdout_mock.__next( :print ) do |command| 
      assert_equal( "GO\n", command, '���s���ꂽ�R�}���h���������Ȃ�' )
    end
    $stdin_mock = Mock.new( '#<STDIN (Mock)>' )
    $stdin_mock.__next( :gets ) do '0' end    
    Debconf::Client.go
  end
  
  # Debconf �� GET �R�}���h���m�F
  public
  def test_get
    $stdout_mock = Mock.new( '#<STDOUT (Mock)>' )
    $stdout_mock.__next( :print ) do |command| 
      assert_equal( "GET QUESTION\n", command, '���s���ꂽ�R�}���h���������Ȃ�' )
    end
    $stdin_mock = Mock.new( '#<STDIN (Mock)>' )
    $stdin_mock.__next( :gets ) do '0' end    
    Debconf::Client.get( 'QUESTION' )
  end

  # Debconf �� SET �R�}���h���m�F
  public
  def test_set
    $stdout_mock = Mock.new( '#<STDOUT (Mock)>' )
    $stdout_mock.__next( :print ) do |command| 
      assert_equal( "SET QUESTION true\n", command, '���s���ꂽ�R�}���h���������Ȃ�' )
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