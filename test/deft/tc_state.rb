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
  # transit ���\�b�h���A�u�X�g���N�g�ł��邱�Ƃ��m�F
  public
  def test_transit_not_implemented
    assert_raises( NotImplementedError, "NotImplementedError �� raise ����Ȃ�����" ) do
      Lucie::State.new.transit nil
    end
  end
  
  # marshal ���\�b�h���A�u�X�g���N�g�ł��邱�Ƃ��m�F
  public
  def test_marshal_not_implemented
    assert_raises( NotImplementedError, "NotImplementedError �� raise ����Ȃ�����" ) do
      Lucie::State::marshal nil
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
