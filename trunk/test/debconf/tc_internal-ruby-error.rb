#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'debconf/client'
require 'test/unit'

class TC_InternalRubyError < Test::Unit::TestCase   
  # —áŠO Debconf::Error::InternalRubyError ‚ÌŠm”F
  public
  def test_parse_response_raises_internal_ruby_error
    assert_raises( Debconf::Error::InternalRubyError, 
    'InternalRubyError ‚ª raise ‚³‚ê‚È‚©‚Á‚½' ) do
      Debconf::Client.parse_response( 'RESPONSE' )
    end 
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: