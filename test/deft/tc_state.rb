#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'lucie/state'
require 'test/unit'

class TC_State < Test::Unit::TestCase  
  # transit メソッドがアブストラクトであることを確認
  public
  def test_transit_not_implemented
    assert_raises( NotImplementedError, "NotImplementedError が raise されなかった" ) do
      Lucie::State.new.transit nil
    end
  end
  
  # marshal メソッドがアブストラクトであることを確認
  public
  def test_marshal_not_implemented
    assert_raises( NotImplementedError, "NotImplementedError が raise されなかった" ) do
      Lucie::State::marshal nil
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
