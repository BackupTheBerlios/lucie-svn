#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $Revision$
# License::  GPL2

ENV["DEBIAN_HAS_FRONTEND"] = 'true'
$LOAD_PATH.unshift './lib'

require 'deft'
require 'test/unit'
require 'test/lmp_conf/lucie_vm_template'
require 'test/lmp_conf/lucie_vm_question'

class TC_Deft < Test::Unit::TestCase
  
  # 以下のような文字列が返されることを確認
  #
  #  class Deft::State::LucieVmsetup__Hello < Deft::NoteState
  #    public
  #    def transit( aDebconfContext )
  #      super aDebconfContext
  #      aDebconfContext.current_question = Deft::Question['lucie-vmsetup/num-nodes']
  #      aDebconfContext.current_state    = Deft::ConcreteState['lucie-vmsetup/num-nodes']
  #    end
  #  end
  public
  def test_ruby_code
    line = DeftApp.instance.ruby_code( 'lucie-vmsetup/hello' ).split("\n")
    
    assert_match /class Deft::State::LucieVmsetup__Hello < Deft::NoteState/, line[0]
    assert_match /public/, line[1]
    assert_match /def transit\( aDebconfContext \)/, line[2]
    assert_match /super aDebconfContext/, line[3]
    assert_match /aDebconfContext\.current_question = Deft::Question\['lucie-vmsetup\/num-nodes'\]/, line[4]
    assert_match /aDebconfContext.current_state\s*=\s*Deft::ConcreteState\['lucie-vmsetup\/num-nodes'\]/, line[5]
    assert_match /end/, line[6]
    assert_match /end/, line[7]    
  end 
  
  # 以下のような文字列が返されることを確認
  #
  #  Template: lucie-vmsetup/hello
  #  Type: note
  #  Description: Hello!
  #   Welcome to Lucie VM setup wizard.
  #  Description-ja: こんにちは
  #   Lucie VM のセットアップウィザードへようこそ
  public
  def test_template
    line = DeftApp.instance.template( 'lucie-vmsetup/hello' ).split("\n")
    
    assert_match /Template: lucie-vmsetup\/hello/, line[0]
    assert_match /Type: note/, line[1]
    assert_match /Description: Hello!/, line[2]
    assert_match /Welcome to Lucie VM setup wizard\./, line[3]
    assert_match /Description-ja: こんにちは/s, line[4]
    assert_match /Lucie VM のセットアップウィザードへようこそ/s, line[5]    
  end
  
  public
  def test_main
    DeftApp.instance.main
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: