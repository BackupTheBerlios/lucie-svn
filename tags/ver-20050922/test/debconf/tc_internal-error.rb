#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'debconf/client'
require 'test/unit'

class TC_InternalError < Test::Unit::TestCase
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
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: