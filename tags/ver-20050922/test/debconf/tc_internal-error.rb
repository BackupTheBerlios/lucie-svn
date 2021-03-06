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
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: