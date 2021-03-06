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
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: