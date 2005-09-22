#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'debconf/client'
require 'test/unit'

class TC_InvalidParametersException < Test::Unit::TestCase  
  # �Ԃ�l 10-19 �ŗ�O Debconf::Exception::InvalidParametersException �̊m�F
  public
  def test_parse_response_raises_invalid_parameters_exception
    assert_raises( Debconf::Exception::InvalidParametersException, 
                   'InvalidParametersException �� raise ����Ȃ�����' ) do 
      Debconf::Client.parse_response( '10 RESPONSE' ) # ���E����
    end
    
    assert_raises( Debconf::Exception::InvalidParametersException, 
                   'InvalidParametersException �� raise ����Ȃ�����' ) do 
      Debconf::Client.parse_response( '15 RESPONSE' )
    end
    
    assert_raises( Debconf::Exception::InvalidParametersException, 
                   'InvalidParametersException �� raise ����Ȃ�����' ) do 
      Debconf::Client.parse_response( '19 RESPONSE' ) # ���E����
    end    
  end
end  

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: