#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

ENV["DEBIAN_HAS_FRONTEND"] = 'true' # debconf/client.rb �̃G���[�����
$LOAD_PATH.unshift './lib'

require 'mock'
require 'deft/debconf-context'
require 'test/unit'

class TC_DebconfContext < Test::Unit::TestCase  
  #--
  # FIXME : Question �ƑΉ����� Template �� require �̏��ŃG���[���N����̂��C��
  #++
  public
  def setup
    require 'test/lmp_conf/lucie_vm_template'
    require 'test/lmp_conf/lucie_vm_question'      
    @debconf_context = Deft::DebconfContext.new
  end
  
  # transit �Ŏ��� State �֑J�ڂ��邱�Ƃ��m�F
  public
  def test_transit
    stdout = Mock.new( '[STDOUT]' )
    stdout.__next( :print ) do |output| assert_equal "INPUT medium lucie-vmsetup/hello\n", output end
    stdout.__next( :print ) do |output| assert_equal "GO\n", output end
    
    stdin = Mock.new( '[STDIN]' )
    stdin.__next( :gets ) do || '0 TRUE' end
    stdin.__next( :gets ) do || '0 TRUE' end
    
    @debconf_context.stdout = stdout    
    @debconf_context.stdin = stdin    
    @debconf_context.transit
    assert_equal 'lucie-vmsetup/num-nodes', @debconf_context.current_question.name
    assert_equal 'Deft::State::LucieVmsetup__NumNodes', @debconf_context.current_state.class.to_s
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
