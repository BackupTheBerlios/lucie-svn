#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'deft/debconf-context'
require 'deft/question'
require 'deft/state'
require 'mock'
require 'test/unit'

class TC_StateTransitBackup < Test::Unit::TestCase
  public
  def setup
    clear
  end
  
  public
  def teardown
    clear
  end
  
  public
  def test_transit
    template( 'start' ) do |template|
      template.template_type = 'note'
      template.short_description_ja = 'スタート'
      template.extended_description_ja = 'スタート'
    end    
    question( 'start' => 'error' ) do |question|
      question.priority = Deft::Question::PRIORITY_MEDIUM
      question.first_question = true
    end    
    template( 'error' ) do |template|
      template.template_type = 'note'
      template.short_description_ja = 'エラーメッセージ'
      template.extended_description_ja = 'エラーメッセージ'
    end    
    question( 'error' ) do |question|
      question.priority = Deft::Question::PRIORITY_MEDIUM
      question.backup = true
    end
    
    debconf_context = Deft::DebconfContext.new
    
    $stdout_mock = Mock.new( '#<STDOUT (Mock)>' )
    $stdin_mock = Mock.new( '#<STDIN (Mock)>' )
    $stdout_mock.__next( :print ) do |argument| 
      assert_equal( "FSET start seen false\n", argument ) 
    end
    $stdin_mock.__next( :gets ) do '0' end
    $stdout_mock.__next( :print ) do |argument| 
      assert_equal( "INPUT medium start\n", argument ) 
    end
    $stdin_mock.__next( :gets ) do '0' end    
    $stdout_mock.__next( :print ) do |argument| 
      assert_equal( "GO\n", argument ) 
    end    
    $stdin_mock.__next( :gets ) do '0' end
    
    $stdout_mock.__next( :print ) do |argument| 
      assert_equal( "FSET error seen false\n", argument ) 
    end
    $stdin_mock.__next( :gets ) do '0' end
    $stdout_mock.__next( :print ) do |argument| 
      assert_equal( "INPUT medium error\n", argument ) 
    end
    $stdin_mock.__next( :gets ) do '0' end    
    $stdout_mock.__next( :print ) do |argument| 
      assert_equal( "GO\n", argument ) 
    end    
    $stdin_mock.__next( :gets ) do '0' end    
    
    # start -> error -> start と遷移
    debconf_context.transit
    debconf_context.transit
    
    assert_equal( Deft::ConcreteState['start'], debconf_context.current_state )
    
    $stdout_mock.__verify
    $stdin_mock.__verify
  end 
  
  private
  def clear
    Deft::Template.clear
    Deft::Question.clear
    Deft::ConcreteState.clear
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
