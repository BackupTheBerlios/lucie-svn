#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'mock'
require 'lucie/boolean-state'
require 'test/unit'

class TC_NoteState < Test::Unit::TestCase
  # 以下のようなクラスをあらわす文字列が返されることを確認
  #
  #  class LucieVmsetup__UseNetwork < Lucie::BooleanState
  #    public
  #    def transit( aDebconfContext )
  #      aDebconfContext.current_state = aDebconfContext::STATES[@question.next_question[get( 'lucie-vmsetup/use-network' )]]
  #    end
  #  end
  public
  def test_marshal
    question = Mock.new( 'lucie-vmsetup/use-network' )
    question.__next( :name ) do || 'lucie-vmsetup/use-network' end
    question.__next( :name ) do || 'lucie-vmsetup/use-network' end
  
    line = Lucie::BooleanState::marshal( question ).split("\n")
    assert_match /class LucieVmsetup__UseNetwork < Lucie::BooleanState/, line[0]
    assert_match /public/, line[1]
    assert_match /def transit\( aDebconfContext \)/, line[2]
    assert_match /aDebconfContext.current_state = aDebconfContext::STATES\[@question\.next_question\[get\( 'lucie-vmsetup\/use-network' \)\]\]/, line[3]
    assert_match /end/, line[4]
    assert_match /end/, line[5]
    question.__verify
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
