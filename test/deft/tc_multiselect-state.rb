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
  # 以下のようなクラスをあらわす文字列が返されることを確認
  #
  #  class Deft::State::LucieVmsetup__Application < Deft::MultiselectState
  #    public
  #    def transit( aDebconfContext )
  #      super aDebconfContext
  #      aDebconfContext.current_question = Deft::Question['lucie-vmsetup/finish']
  #      aDebconfContext.current_state    = Deft::ConcreteState['lucie-vmsetup/finish']
  #    end
  #  end
  public
  def test_marshal
    question = Mock.new( 'lucie-vmsetup/application' )
    question.__next( :state_class_name ) do || 'Deft::State::LucieVmsetup__Application' end
    question.__next( :next_question ) do || 'lucie-vmsetup/finish' end
    question.__next( :next_question ) do || 'lucie-vmsetup/finish' end 
    
    line = Deft::MultiselectState::marshal_concrete_state( question ).split("\n")
    assert_match /class Deft::State::LucieVmsetup__Application < Deft::MultiselectState/, line[0]
    assert_match /public/, line[1]
    assert_match /def transit\( aDebconfContext \)/, line[2]
    assert_match /super aDebconfContext/, line[3]
    assert_match /aDebconfContext.current_question = Deft::Question\['lucie-vmsetup\/finish'\]/, line[4]
    assert_match /aDebconfContext.current_state\s*= Deft::ConcreteState\['lucie-vmsetup\/finish'\]/, line[5]
    assert_match /end/, line[6]
    assert_match /end/, line[7]
    question.__verify
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: