#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'mock'
require 'deft/note-state'
require 'test/unit'

class TC_NoteState < Test::Unit::TestCase
  # 以下のようなクラスをあらわす文字列が返されることを確認
  #
  #  class Lucie__Overview < Deft::NoteState
  #    public
  #    def transit( aDebconfContext )
  #      super aDebconfContext
  #      aDebconfContext.current_state = DebconfContext::STATES['lucie/caution']
  #    end
  #  end
  public
  def test_marshal
    question = Mock.new( 'lucie/overview' )
    question.__next( :state_class_name ) do || 'Deft::State::Lucie__Overview' end
    question.__next( :next_question ) do || 'lucie/caution' end
    question.__next( :next_question ) do || 'lucie/caution' end    
    line = Deft::NoteState::marshal_concrete_state( question ).split("\n")
    assert_match /class Deft::State::Lucie__Overview < Deft::NoteState/, line[0]
    assert_match /public/, line[1]
    assert_match /def transit\( aDebconfContext \)/, line[2]
    assert_match /super aDebconfContext/, line[3]
    assert_match /aDebconfContext.current_question\s*= Deft::Question\['lucie\/caution'\]/, line[4]
    assert_match /aDebconfContext.current_state\s*= Deft::ConcreteState\['lucie\/caution'\]/, line[5]
    assert_match /end/, line[6]
    assert_match /end/, line[7]
    question.__verify
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
