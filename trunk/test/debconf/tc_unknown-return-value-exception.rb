#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'debconf/client'
require 'test/unit'

class TC_UnknownReturnValueException < Test::Unit::TestCase  
  # �Ԃ�l 256- �� UnknownReturnValueException ���Ԃ邱�Ƃ��m�F
  public
  def test_parse_response_raises_unknown_return_value_exception
    assert_raises( Debconf::Exception::UnknownReturnValueException,
                   'UnknownReturnValueException �� raise ����Ȃ�����' ) do
      Debconf::Client.parse_response( '256 RESPONSE' ) # ���E����
    end
    
    assert_raises( Debconf::Exception::UnknownReturnValueException,
                   'UnknownReturnValueException �� raise ����Ȃ�����' ) do
      Debconf::Client.parse_response( '266 RESPONSE' )
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: