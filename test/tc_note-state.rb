#
# $Id: tc_state.rb 49 2005-02-07 04:30:20Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 49 $
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'mock'
require 'lucie/note-state'
require 'test/unit'

class TC_NoteState < Test::Unit::TestCase
  public
  def test_NoteState_inherited_from_State
    assert( Lucie::NoteState < Lucie::State, "NoteState クラスが State を継承していない" )
  end
  
  # 以下のようなクラスをあらわす文字列が返されることを確認
  #
  #  class Overview < Lucie::NoteState
  #    public
  #    def transit( aDebconfContext )
  #      aDebconfContext.current_state = DebconfContext::PACKAGE_INFORMATION
  #    end
  #  end
  public
  def test_marshal
    question = Mock.new
    question.__next( :next ) do || 'DebconfContext::PACKAGE_INFORMATION' end
    question.__next( :klass ) do || 'Overview < Lucie::NoteState' end
    
    eval Lucie::NoteState::marshal( question )
    assert Overview < Lucie::NoteState, "Overview クラスが Lucie::NoteState を継承していない"
    question.__verify
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
