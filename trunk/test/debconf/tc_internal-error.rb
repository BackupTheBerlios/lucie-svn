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
  # •Ô‚è’l 100-109 ‚Å —áŠO Debconf::Error::InternalError ‚ÌŠm”F
  public
  def test_parse_response_raises_internal_error
    assert_raises( Debconf::Error::InternalError,
                   'Debconf::Error::InternalError ‚ª raise ‚³‚ê‚È‚©‚Á‚½' ) do
      Debconf::Client.parse_response( '100 RESPONSE' ) # ‹«ŠEðŒ
    end
    
    assert_raises( Debconf::Error::InternalError,
                   'Debconf::Error::InternalError ‚ª raise ‚³‚ê‚È‚©‚Á‚½' ) do
      Debconf::Client.parse_response( '105 RESPONSE' )
    end
    
    assert_raises( Debconf::Error::InternalError,
                   'Debconf::Error::InternalError ‚ª raise ‚³‚ê‚È‚©‚Á‚½' ) do
      Debconf::Client.parse_response( '109 RESPONSE' ) # ‹«ŠEðŒ
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: