#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'mock'
require 'lucie/multiselect-state'
require 'test/unit'

class TC_MultiselectState < Test::Unit::TestCase
  # 以下のようなクラスをあらわす文字列が返されることを確認
  #
  #  class LucieVmsetup__Application < Lucie::MultiselectState
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
    
    line = Lucie::MultiselectState::marshal( question ).split("\n")
    assert_match /class LucieVmsetup__Application < Lucie::MultiselectState/, line[0]
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