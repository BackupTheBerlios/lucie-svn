#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'mock'
require 'lucie/text-state'
require 'test/unit'

class TC_TextState < Test::Unit::TestCase
  # 以下のようなクラスをあらわす文字列が返されることを確認
  #
  #  class Lucie__Overview < Lucie::TextState
  #    public
  #    def transit( aDebconfContext )
  #      aDebconfContext.current_state = Lucie__Caution
  #    end
  #  end
  public
  def test_marshal
    question = Mock.new( 'lucie/overview' )
    question.__next( :name ) do || 'lucie/overview' end
    question.__next( :next_question ) do || 'lucie/caution' end    
    line = Lucie::TextState::marshal( question ).split("\n")
    assert_match /class Lucie__Overview < Lucie::TextState/, line[0]
    assert_match /public/, line[1]
    assert_match /def transit\( aDebconfContext \)/, line[2]
    assert_match /aDebconfContext.current_state = Lucie__Caution/, line[3]
    assert_match /end/, line[4]
    assert_match /end/, line[5]
    question.__verify
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
