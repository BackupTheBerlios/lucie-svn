#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'deft/string-state'
require 'mock'
require 'test/unit'

class TC_StringState < Test::Unit::TestCase
  # 以下のようなクラスをあらわす文字列が返されることを確認
  #
  #  class Deft::State::Lucie__Overview < Deft::StringState
  #    public
  #    def transit( aDebconfContext )
  #      super aDebconfContext
  #      aDebconfContext.current_question = Deft::Question['lucie/caution']
  #      aDebconfContext.current_state    = Deft::ConcreteState['lucie/caution']
  #    end
  #  end
  public
  def test_marshal
    question = Mock.new( 'lucie/overview' )
    question.__next( :state_class_name ) do || 'Deft::State::Lucie__Overview' end 
    question.__next( :next_question ) do || 'lucie/caution' end   
    question.__next( :next_question ) do || 'lucie/caution' end     
    line = Deft::StringState::marshal_concrete_state( question ).split("\n")
    assert_match /class Deft::State::Lucie__Overview < Deft::StringState/, line[0]
    assert_match /public/, line[1]
    assert_match /def transit\( aDebconfContext \)/, line[2]
    assert_match /super aDebconfContext/, line[3]
    assert_match /aDebconfContext.current_question = Deft::Question\['lucie\/caution'\]/, line[4]
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