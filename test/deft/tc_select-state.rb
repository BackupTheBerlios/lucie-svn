#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'deft/select-state'
require 'mock'
require 'test/unit'

class TC_SelectState < Test::Unit::TestCase
  # 以下のようなクラスをあらわす文字列が返されることを確認
  #
  #  class Deft::State::LucieVmsetup__VmType < Deft::SelectState
  #    public
  #    def transit( aDebconfContext )
  #      super aDebconfContext
  #      aDebconfContext.current_question = Deft::Question['lucie-vmsetup/distro']
  #      aDebconfContext.current_state    = Deft::ConcreteState['lucie-vmsetup/distro']
  #    end
  #  end
  public
  def test_marshal
    question = Mock.new( 'lucie-vmsetup/vm-type' )
    question.__next( :state_class_name ) do || 'Deft::State::LucieVmsetup__VmType' end
    question.__next( :next_question ) do || 'lucie-vmsetup/distro' end
    question.__next( :next_question ) do || 'lucie-vmsetup/distro' end 
    
    line = Deft::SelectState::marshal_concrete_state( question ).split("\n")
    assert_match /class Deft::State::LucieVmsetup__VmType < Deft::SelectState/, line[0]
    assert_match /public/, line[1]
    assert_match /def transit\( aDebconfContext \)/, line[2]
    assert_match /super aDebconfContext/, line[3]
    assert_match /aDebconfContext.current_question = Deft::Question\['lucie-vmsetup\/distro'\]/, line[4]
    assert_match /aDebconfContext.current_state\s*= Deft::ConcreteState\['lucie-vmsetup\/distro'\]/, line[5]
    assert_match /end/, line[6]
    assert_match /end/, line[7]
    question.__verify
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
