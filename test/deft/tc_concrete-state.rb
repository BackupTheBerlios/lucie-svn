#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'data/lucie_vm_template'  
require 'deft/concrete-state'
require 'test/unit'

class TC_ConcreteState < Test::Unit::TestCase
  public
  def test_concrete_state
    assert_equal( 9, Deft::ConcreteState.states.size, 'Concrete State の数が違う' )
  end
  
  public
  def test_lookup
    assert_equal( 'Deft::State::LucieVmsetup__Ip', Deft::ConcreteState['lucie-vmsetup/ip'].class.to_s,
                  'Concrete State が名前で引けない' )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
