#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'deft/boolean-state'
require 'mock'
require 'test/unit'

class TC_NoteState < Test::Unit::TestCase
  # 以下のようなクラスをあらわす文字列が返されることを確認
  #
  #  class Deft::State::LucieVmsetup__UseNetwork < Deft::BooleanState
  #    public
  #    def transit( aDebconfContext )
  #      super aDebconfContext
  #      next_question = aDebconfContext.current_question.next_question[get( 'lucie-vmsetup/use-network' )]
  #      aDebconfContext.current_question = Deft::Question[next_question]
  #      aDebconfContext.current_state    = Deft::ConcreteState[next_question] 
  #    end
  #  end
  public
  def test_marshal
    question = Mock.new( 'lucie-vmsetup/use-network' )
    question.__next( :state_class_name ) do || 'Deft::State::LucieVmsetup__UseNetwork' end
    question.__next( :name ) do || 'lucie-vmsetup/use-network' end
  
    line = Deft::BooleanState::marshal_concrete_state( question ).split("\n")
    assert_match /class Deft::State::LucieVmsetup__UseNetwork < Deft::BooleanState/, line[0]
    assert_match /public/, line[1]
    assert_match /def transit\( aDebconfContext \)/, line[2]
    assert_match /super aDebconfContext/, line[3]
    assert_match /next_question = aDebconfContext\.current_question\.next_question\[get\( 'lucie-vmsetup\/use-network' \)\]/, line[4]
    assert_match /aDebconfContext\.current_question\s*= Deft::Question\[next_question\]/, line[5]
    assert_match /aDebconfContext\.current_state\s*= Deft::ConcreteState\[next_question\]/, line[6]
    assert_match /end/, line[7]
    assert_match /end/, line[8]
    question.__verify
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
