#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'deft/concrete-state'
require 'data/lucie_vm_template' 
require 'mock'
require 'deft/state'
require 'deft/debconf-context'
require 'test/unit'

# FIXME : テスト対象を最低限にして、テンプレート/Question の定義をここでやってしまう。
class TC_DebconfContext < Test::Unit::TestCase  
  public
  def setup        
    @debconf_context = Deft::DebconfContext.new
  end
  
  # transit で次の State へ遷移することを確認
  public
  def test_transit
    $stdout_mock = Mock.new( '[STDOUT]' )
    $stdout_mock.__next( :print ) do |output| 
      assert_equal( "INPUT medium lucie-vmsetup/hello\n", output )
    end
    $stdout_mock.__next( :print ) do |output|
      assert_equal( "GO\n", output )
    end
    $stdin_mock = Mock.new( '[STDIN]' )
    $stdin_mock.__next( :gets ) do '0 TRUE' end
    $stdin_mock.__next( :gets ) do '0 TRUE' end
    
    @debconf_context.transit
    assert_equal 'lucie-vmsetup/num-nodes', @debconf_context.current_state.name
    assert_equal 'Deft::State::LucieVmsetup__NumNodes', @debconf_context.current_state.class.to_s
    
    $stdout_mock.__verify
    $stdin_mock.__verify
  end
  
  # 状態遷移の開始地点の State が取得できることを確認
  public
  def test_start_state
    assert_kind_of Deft::State, @debconf_context.current_state
    assert_equal 'Deft::State::LucieVmsetup__Hello', @debconf_context.current_state.class.to_s
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
