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

# FIXME : �e�X�g�Ώۂ��Œ���ɂ��āA�e���v���[�g/Question �̒�`�������ł���Ă��܂��B
class TC_DebconfContext < Test::Unit::TestCase  
  public
  def setup        
    @debconf_context = Deft::DebconfContext.new
  end
  
  # transit �Ŏ��� State �֑J�ڂ��邱�Ƃ��m�F
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
  
  # ��ԑJ�ڂ̊J�n�n�_�� State ���擾�ł��邱�Ƃ��m�F
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
