#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'deft/concrete-state'
require 'deft/question'
require 'deft/boolean-state'
require 'mock'
require 'test/unit'

class TC_BooleanState < Test::Unit::TestCase 
  # next_question が String オブジェクトのときをテスト
  public
  def test_marshal_next_string   
    question = Mock.new( '#<Question (Mock)>' )
    question.__next( :next_question ) do "'lucie-vmsetup/next'" end  
    question.__next( :state_class_name ) do 'Deft::State::LucieVmsetup__UseNetwork' end
    question.__next( :next_question ) do "'lucie-vmsetup/next'" end 
    
    eval list = Deft::BooleanState::marshal_concrete_state( question )

    debconf_context = Mock.new( '#<DebconfContext (Mock)>' )
    current_question = Mock.new( '#<Question (Mock)>' )
    debconf_context.__next( :current_question ) do current_question end
    debconf_context.__next( :current_question ) do current_question end
    debconf_context.__next( :current_state= ) do end
    current_question.__next( :priority ) do Deft::Question::PRIORITY_MEDIUM end
    current_question.__next( :name ) do 'lucie-vmsetup/use-network' end
    
    # -> INPUT medium lucie-vmsetup/use-network\n
    # <- 0
    # -> GO\n
    # <- 0
    $stdout_mock = Mock.new( '#<STDOUT (Mock)>' )
    $stdin_mock = Mock.new( '#<STDIN (Mock)>' )    
    $stdout_mock.__next( :print ) do |command| 
      assert_equal( "INPUT medium lucie-vmsetup/use-network\n", command )
    end
    $stdout_mock.__next( :print ) do |command| 
      assert_equal( "GO\n", command )
    end
    $stdin_mock.__next( :gets ) do '0' end
    $stdin_mock.__next( :gets ) do '0' end
    Deft::State::LucieVmsetup__UseNetwork.instance.transit( debconf_context )    
    question.__verify    
    $stdout_mock.__verify
    $stdin_mock.__verify
  end
  
  # next_question が Hash オブジェクトのときをテスト
  public
  def test_marshal_next_hash
    question = Mock.new( '#<Question (Mock)>' )
    question.__next( :next_question ) do "{ 'true' => 'lucie-vmsetup/true', 'false' => 'lucie-vmsetup/false' }" end  
    question.__next( :name ) do 'lucie-vmsetup/use-network' end   
    question.__next( :state_class_name ) do 'Deft::State::LucieVmsetup__UseNetwork' end
    question.__next( :next_question ) do "{ 'true' => 'lucie-vmsetup/true', 'false' => 'lucie-vmsetup/false' }" end  
    
    eval list = Deft::BooleanState::marshal_concrete_state( question ) 
    
    debconf_context = Mock.new( '#<DebconfContext (Mock)>' )
    current_question = Mock.new( '#<Question (Mock)>' )
    debconf_context.__next( :current_question ) do current_question end
    debconf_context.__next( :current_question ) do current_question end
    debconf_context.__next( :current_state= ) do end
    current_question.__next( :priority ) do Deft::Question::PRIORITY_MEDIUM end
    current_question.__next( :name ) do 'lucie-vmsetup/use-network' end
    
    # -> INPUT medium lucie-vmsetup/use-network\n
    # <- 0
    # -> GO\n
    # <- 0
    # -> GET lucie-vmsetup/use-network\n
    # <- 0
    $stdout_mock = Mock.new( '#<STDOUT (Mock)>' )
    $stdin_mock = Mock.new( '#<STDIN (Mock)>' )    
    $stdout_mock.__next( :print ) do |command| 
      assert_equal( "INPUT medium lucie-vmsetup/use-network\n", command )
    end
    $stdout_mock.__next( :print ) do |command| 
      assert_equal( "GO\n", command )
    end
    $stdout_mock.__next( :print ) do |command| 
      assert_equal( "GET lucie-vmsetup/use-network\n", command )
    end
    $stdin_mock.__next( :gets ) do '0' end
    $stdin_mock.__next( :gets ) do '0' end
    $stdin_mock.__next( :gets ) do '0' end
    
    Deft::State::LucieVmsetup__UseNetwork.instance.transit( debconf_context )    
    question.__verify
    $stdout_mock.__verify
    $stdin_mock.__verify
  end
  
  # next_question が Proc オブジェクトのときをテスト
  public
  def test_marshal_next_proc    
    next_question = <<-NEXT_QUESTION
    Proc.new do |user_input|
      case user_input
      when 'debian (woody)', 'debian (sarge)'
        'lucie-vmsetup/debian'
      when 'redhat7.3'
        'lucie-vmsetup/redhat'
      end
    end
    NEXT_QUESTION
    
    question = Mock.new( '#<Question (Mock)>' )
    question.__next( :next_question ) do next_question end  
    question.__next( :name ) do 'lucie-vmsetup/use-network' end   
    question.__next( :state_class_name ) do 'Deft::State::LucieVmsetup__UseNetwork' end
    question.__next( :next_question ) do next_question end  
    
    eval list = Deft::BooleanState::marshal_concrete_state( question )
    
    # -> INPUT medium lucie-vmsetup/use-network\n
    # <- 0
    # -> GO\n
    # <- 0
    # -> GET lucie-vmsetup/use-network\n
    # <- 0
    debconf_context = Mock.new( '#<DebconfContext (Mock)>' )
    current_question = Mock.new( '#<Question (Mock)>' )
    debconf_context.__next( :current_question ) do current_question end
    debconf_context.__next( :current_question ) do current_question end
    debconf_context.__next( :current_state= ) do end
    current_question.__next( :priority ) do Deft::Question::PRIORITY_MEDIUM end
    current_question.__next( :name ) do 'lucie-vmsetup/use-network' end
    
    $stdout_mock = Mock.new( '#<STDOUT (Mock)>' )
    $stdin_mock = Mock.new( '#<STDIN (Mock)>' )
    
    $stdout_mock.__next( :print ) do |command| 
      assert_equal( "INPUT medium lucie-vmsetup/use-network\n", command )
    end
    $stdout_mock.__next( :print ) do |command| 
      assert_equal( "GO\n", command )
    end
        $stdout_mock.__next( :print ) do |command| 
      assert_equal( "GET lucie-vmsetup/use-network\n", command )
    end
    $stdin_mock.__next( :gets ) do '0' end
    $stdin_mock.__next( :gets ) do '0' end
    $stdin_mock.__next( :gets ) do '0' end
    
    Deft::State::LucieVmsetup__UseNetwork.instance.transit( debconf_context )
    question.__verify
    $stdout_mock.__verify
    $stdin_mock.__verify
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
