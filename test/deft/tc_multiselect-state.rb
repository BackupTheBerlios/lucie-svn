#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'deft/multiselect-state'
require 'mock'
require 'test/unit'

class TC_MultiselectState < Test::Unit::TestCase
  # �ȉ��̂悤�ȃN���X������킷�����񂪕Ԃ���邱�Ƃ��m�F
  #
  #  class LucieVmsetup__Application < Deft::MultiselectState
  #    public
  #    def transit( aDebconfContext )
  #      super aDebconfContext
  #      aDebconfContext.current_state = DebconfContext::STATES['lucie-vmsetup/finish']
  #    end
  #  end
  public
  def test_marshal
    question = Mock.new( 'lucie-vmsetup/application' )
    question.__next( :name ) do || 'lucie-vmsetup/application' end
    question.__next( :next_question ) do || 'lucie-vmsetup/finish' end 
    
    line = Deft::MultiselectState::marshal( question ).split("\n")
    assert_match /class LucieVmsetup__Application < Deft::MultiselectState/, line[0]
    assert_match /public/, line[1]
    assert_match /def transit\( aDebconfContext \)/, line[2]
    assert_match /super aDebconfContext/, line[3]
    assert_match /aDebconfContext.current_state = DebconfContext::STATES\['lucie-vmsetup\/finish'\]/, line[4]
    assert_match /end/, line[5]
    assert_match /end/, line[6]
    question.__verify
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: