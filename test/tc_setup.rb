#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'lucie/lucie-setup'
require 'test/unit'

class TC_Setup < Test::Unit::TestCase
  public
  def test_singleton
    assert Lucie::Setup::include?( Singleton )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
