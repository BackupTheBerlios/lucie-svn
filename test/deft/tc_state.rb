#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'deft/question'
require 'deft/state'
require 'mock'
require 'test/unit'

class TC_State < Test::Unit::TestCase 
  # next_question が nil のときをテスト
  public
  def test_marshal_next_nil
    question = Mock.new( '#<Question (Mock)>' )
    question.__next( :backup ) do false end
    question.__next( :next_question ) do nil end
    question.__next( :state_class_name ) do 'Deft::State::LucieVmsetup__UseNetwork' end
    
    list = Deft::State::marshal_concrete_state( question )
    eval list
    
    debconf_context = Mock.new( '#<DebconfContext (Mock)>' )
    current_state = Mock.new( '#<ConcreteState (Mock)>' )
    current_state.__next( :priority ) do Deft::Question::PRIORITY_MEDIUM end
    current_state.__next( :name ) do 'lucie-vmsetup/use-network' end
    debconf_context.__next( :current_state ) do current_state end
    debconf_context.__next( :current_state ) do current_state end
    debconf_context.__next( :current_state ) do current_state end
    debconf_context.__next( :current_state ) do current_state end
    debconf_context.__next( :current_state= ) do |next_state| 
      assert_nil( next_state, "遷移先の Concrete State が正しくない" )
    end    
    
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
    
    assert_nil( Deft::State::LucieVmsetup__UseNetwork.instance.transit( debconf_context ),
                'transit の返り値が nil でない' )
       
    question.__verify    
    $stdout_mock.__verify
    $stdin_mock.__verify
  end

  # next_question が String オブジェクトのときをテスト
  public
  def test_marshal_next_string   
    question = Mock.new( '#<Question (Mock)>' )
    question.__next( :backup ) do false end
    question.__next( :next_question ) do 'lucie-vmsetup/next' end 
    question.__next( :next_question ) do 'lucie-vmsetup/next' end 
    question.__next( :state_class_name ) do 'Deft::State::LucieVmsetup__UseNetwork' end  
    question.__next( :next_question ) do 'lucie-vmsetup/next' end      
    
    list = Deft::State::marshal_concrete_state( question )
    eval list

    debconf_context = Mock.new( '#<DebconfContext (Mock)>' )
    current_state = Mock.new( '#<ConcreteState (Mock)>' )
    current_state.__next( :priority ) do Deft::Question::PRIORITY_MEDIUM end
    current_state.__next( :name ) do 'lucie-vmsetup/use-network' end
    debconf_context.__next( :current_state ) do current_state end
    debconf_context.__next( :current_state ) do current_state end
    debconf_context.__next( :current_state ) do current_state end
    debconf_context.__next( :current_state ) do current_state end
    debconf_context.__next( :current_state= ) do |next_state| 
      assert_equal( Deft::ConcreteState['lucie-vmsetup/next'], next_state, 
                    "遷移先の Concrete State が正しくない" )
    end
    
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
    question.__next( :backup ) do false end
    question.__next( :next_question ) do { 'true' => 'lucie-vmsetup/true', 'false' => 'lucie-vmsetup/false' } end  
    question.__next( :next_question ) do { 'true' => 'lucie-vmsetup/true', 'false' => 'lucie-vmsetup/false' } end 
    question.__next( :next_question ) do { 'true' => 'lucie-vmsetup/true', 'false' => 'lucie-vmsetup/false' } end 
    question.__next( :name ) do 'lucie-vmsetup/use-network' end   
    question.__next( :state_class_name ) do 'Deft::State::LucieVmsetup__UseNetwork' end     
    
    list = Deft::State::marshal_concrete_state( question )
    eval list 
    
    debconf_context = Mock.new( '#<DebconfContext (Mock)>' )
    current_state = Mock.new( '#<ConcreteState (Mock)>' )
    current_state.__next( :priority ) do Deft::Question::PRIORITY_MEDIUM end
    current_state.__next( :name ) do 'lucie-vmsetup/use-network' end    
    debconf_context.__next( :current_state ) do current_state end
    debconf_context.__next( :current_state ) do current_state end
    debconf_context.__next( :current_state ) do current_state end 
    debconf_context.__next( :current_state ) do current_state end    
    debconf_context.__next( :current_state= ) do end
    
    # -> INPUT medium lucie-vmsetup/use-network\n
    # <- 0
    # -> GO\n
    # <- 0
    # -> GET lucie-vmsetup/use-network\n
    # <- 0 true
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
    question.__next( :backup ) do false end
    question.__next( :next_question ) do next_question end
    question.__next( :next_question ) do next_question end 
    question.__next( :next_question ) do next_question end 
    question.__next( :name ) do 'lucie-vmsetup/use-network' end   
    question.__next( :state_class_name ) do 'Deft::State::LucieVmsetup__UseNetwork' end
    
    list = Deft::State::marshal_concrete_state( question )
    eval list
    
    # -> INPUT medium lucie-vmsetup/use-network\n
    # <- 0
    # -> GO\n
    # <- 0
    # -> GET lucie-vmsetup/use-network\n
    # <- 0
    debconf_context = Mock.new( '#<DebconfContext (Mock)>' )
    current_state = Mock.new( '#<ConcreteState (Mock)>' )
    debconf_context.__next( :current_state ) do current_state end
    debconf_context.__next( :current_state ) do current_state end
    debconf_context.__next( :current_state ) do current_state end
    debconf_context.__next( :current_state ) do current_state end
    debconf_context.__next( :current_state= ) do end
    current_state.__next( :priority ) do Deft::Question::PRIORITY_MEDIUM end
    current_state.__next( :name ) do 'lucie-vmsetup/use-network' end
    
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
