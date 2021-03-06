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
  # 返り値 10-19 で例外 Debconf::Exception::InvalidParametersException の確認
  public
  def test_parse_response_raises_invalid_parameters_exception
    assert_raises( Debconf::Exception::InvalidParametersException, 
                   'InvalidParametersException が raise されなかった' ) do 
      Debconf::Client.parse_response( '10 RESPONSE' ) # 境界条件
    end
    
    assert_raises( Debconf::Exception::InvalidParametersException, 
                   'InvalidParametersException が raise されなかった' ) do 
      Debconf::Client.parse_response( '15 RESPONSE' )
    end
    
    assert_raises( Debconf::Exception::InvalidParametersException, 
                   'InvalidParametersException が raise されなかった' ) do 
      Debconf::Client.parse_response( '19 RESPONSE' ) # 境界条件
    end    
  end
end  

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: