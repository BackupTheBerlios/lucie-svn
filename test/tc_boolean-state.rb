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
  #      aDebconfContext.current_state = \
  #      case get( @question.name )
  #      when 'true'
  #        LucieVmsetup__Ip
  #      when 'false
  #        LucieVmsetup__MemorySize'
  #      else
  #        raise "This shouldn't happen"
  #      end
  #    end
  #  end
  public
  def test_marshal
    question = Mock.new( 'lucie-vmsetup/use-network' )
    question.__next( :next_question ) do || { true=>'lucie-vmsetup/ip', false=>'lucie-vmsetup/memory-size' } end 
    question.__next( :next_question ) do || { true=>'lucie-vmsetup/ip', false=>'lucie-vmsetup/memory-size' } end   
    question.__next( :name ) do || 'lucie-vmsetup/use-network' end
  
    line = Lucie::BooleanState::marshal( question ).split("\n")
    assert_match /class LucieVmsetup__UseNetwork < Lucie::BooleanState/, line[0]
    assert_match /public/, line[1]
    assert_match /def transit\( aDebconfContext \)/, line[2]
    assert_match /aDebconfContext.current_state = \\/, line[3]
    assert_match /case get\( @question.name \)/, line[4]
    assert_match /when 'true'/, line[5]
    assert_match /LucieVmsetup__Ip/, line[6]
    assert_match /when 'false'/, line[7]
    assert_match /LucieVmsetup__MemorySize/, line[8]
    assert_match /else/, line[9]
    assert_match /raise "This shouldn't happen"/, line[10]
    assert_match /end/, line[11]
    assert_match /end/, line[12]
    assert_match /end/, line[13]
    question.__verify
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
