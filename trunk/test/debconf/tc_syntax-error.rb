#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'debconf/client'
require 'test/unit'

class TC_SyntaxError < Test::Unit::TestCase
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
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: