#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

ENV["DEBIAN_HAS_FRONTEND"] = 'true' # debconf/client.rb のエラーを回避
$LOAD_PATH.unshift './lib'

require 'mock'
require 'deft/debconf-context'
require 'test/unit'

class TC_DebconfContext < Test::Unit::TestCase  
  #--
  # FIXME : Question と対応する Template の require の順でエラーが起こるのを修正
  #++
  public
  def setup
    require 'test/lmp_conf/lucie_vm_template'
    require 'test/lmp_conf/lucie_vm_question'      
    @debconf_context = Deft::DebconfContext.new
  end
  
  # transit で次の State へ遷移することを確認
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
