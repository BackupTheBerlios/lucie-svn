#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'mock'
require 'deft/debconf-context'
require 'test/unit'

class TC_DebconfContext < Test::Unit::TestCase  
  public
  def setup
    Deft::Template.clear
    Deft::Question.clear       
    
    template('TEST/TEMPLATE1') do |template|
      template.template_type = 'note'
    end
    template('TEST/TEMPLATE2') do |template|
      template.template_type = 'note'
    end
    
    question('TEST/TEMPLATE1') do |question|
      question.next_question = 'TEST/TEMPLATE2'
      question.priority = Deft::Question::PRIORITY_MEDIUM
      question.first_question = true
    end
    question('TEST/TEMPLATE2') do |question|
      question.priority = Deft::Question::PRIORITY_MEDIUM
    end
    
    @debconf_context = Deft::DebconfContext.new
  end
  
  # transit で次の State へ遷移することを確認
  public
  def test_transit
    $stdout_mock = Mock.new( '[STDOUT]' )
    $stdout_mock.__next( :print ) do |output| 
      assert_equal( "FSET TEST/TEMPLATE1 seen false\n", output )
    end
    $stdout_mock.__next( :print ) do |output| 
      assert_equal( "INPUT medium TEST/TEMPLATE1\n", output )
    end
    $stdout_mock.__next( :print ) do |output|
      assert_equal( "GO\n", output )
    end
    $stdin_mock = Mock.new( '[STDIN]' )
    $stdin_mock.__next( :gets ) do '0 TRUE' end
    $stdin_mock.__next( :gets ) do '0 TRUE' end
    $stdin_mock.__next( :gets ) do '0 TRUE' end
    
    @debconf_context.transit
    assert_equal( 'TEST/TEMPLATE2', @debconf_context.current_state.name )
    assert_equal( 'Deft::State::Test__Template2',
                  @debconf_context.current_state.class.to_s )
    
    $stdout_mock.__verify
    $stdin_mock.__verify
  end
  
  # 状態遷移の開始地点の State が取得できることを確認
  public
  def test_start_state
    assert_kind_of( Deft::State, @debconf_context.current_state )
    assert_equal( 'Deft::State::Test__Template1',
                  @debconf_context.current_state.class.to_s )
  end
  
  public
  def test_backup
    $stdout_mock = Mock.new( '#<STDOUT>' )
    $stdout_mock.__next( :print ) do |output| 
      assert_equal( "FSET TEST/TEMPLATE1 seen false\n", output )
    end
    $stdout_mock.__next( :print ) do |output| 
      assert_equal( "INPUT medium TEST/TEMPLATE1\n", output )
    end
    $stdout_mock.__next( :print ) do |output|
      assert_equal( "GO\n", output )
    end
    $stdin_mock = Mock.new( '#<STDIN>' )
    $stdin_mock.__next( :gets ) do '0 TRUE' end
    $stdin_mock.__next( :gets ) do '0 TRUE' end    
    $stdin_mock.__next( :gets ) do '0 TRUE' end  
    
    first_state = @debconf_context.current_state
    @debconf_context.transit
    assert_equal( first_state, @debconf_context.last_state,
                  '直前の状態が取り出せない' )
    @debconf_context.backup
    assert_equal( first_state, @debconf_context.current_state,
                  'backup で直前の状態に戻らない' )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
