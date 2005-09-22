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

class TC_StateTransitFinish < Test::Unit::TestCase
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
      template.short_description_ja = '��������'
      template.extended_description_ja = '��������'
    end    
    question( 'start' => 'finish' ) do |question|
      question.priority = Deft::Question::PRIORITY_MEDIUM
      question.first_question = true
    end
    
    template( 'finish' ) do |template|
      template.template_type = 'note'
      template.short_description_ja = '�ե��˥å���'
      template.extended_description_ja = '�ե��˥å���'
    end    
    question( 'finish' ) do |question|
      question.priority = Deft::Question::PRIORITY_MEDIUM
    end            
    
    debconf_context = Deft::DebconfContext.new
    
    $stdout_mock = Mock.new( '#<STDOUT (Mock)>' )
    $stdin_mock = Mock.new( '#<STDIN (Mock)>' )
    $stdout_mock.__next( :print ) do |argument| 
      assert_equal( "INPUT medium start\n", argument ) 
    end
    $stdin_mock.__next( :gets ) do '0' end    
    $stdout_mock.__next( :print ) do |argument| 
      assert_equal( "GO\n", argument ) 
    end    
    $stdin_mock.__next( :gets ) do '0' end
    
    $stdout_mock.__next( :print ) do |argument| 
      assert_equal( "INPUT medium finish\n", argument ) 
    end
    $stdin_mock.__next( :gets ) do '0' end    
    $stdout_mock.__next( :print ) do |argument| 
      assert_equal( "GO\n", argument ) 
    end    
    $stdin_mock.__next( :gets ) do '0' end
    
    debconf_context.transit
    assert_equal( Deft::ConcreteState['finish'], debconf_context.current_state )
    assert_nil( debconf_context.transit )
    
    $stdout_mock.__verify
    $stdin_mock.__verify
  end 
  
  public
  def test_transit_backup
    template( 'start' ) do |template|
      template.template_type = 'note'
      template.short_description_ja = '��������'
      template.extended_description_ja = '��������'
    end    
    question( 'start' => 'finish' ) do |question|
      question.priority = Deft::Question::PRIORITY_MEDIUM
      question.first_question = true
    end
    
    template( 'finish' ) do |template|
      template.template_type = 'note'
      template.short_description_ja = '�ե��˥å���'
      template.extended_description_ja = '�ե��˥å���'
    end    
    question( 'finish' ) do |question|
      question.priority = Deft::Question::PRIORITY_MEDIUM
    end            
    
    debconf_context = Deft::DebconfContext.new
    
    $stdout_mock = Mock.new( '#<STDOUT (Mock)>' )
    $stdin_mock = Mock.new( '#<STDIN (Mock)>' )
    $stdout_mock.__next( :print ) do |argument| 
      assert_equal( "INPUT medium start\n", argument ) 
    end
    $stdin_mock.__next( :gets ) do '0' end    
    $stdout_mock.__next( :print ) do |argument| 
      assert_equal( "GO\n", argument ) 
    end    
    $stdin_mock.__next( :gets ) do '0' end
    
    $stdout_mock.__next( :print ) do |argument| 
      assert_equal( "INPUT medium finish\n", argument ) 
    end
    $stdin_mock.__next( :gets ) do '0' end    
    $stdout_mock.__next( :print ) do |argument| 
      assert_equal( "GO\n", argument ) 
    end    
    $stdin_mock.__next( :gets ) do '30' end
    
    #                    backup
    # 'start' -> 'finish' -> 'start'
    debconf_context.transit
    assert_equal( Deft::ConcreteState['start'], debconf_context.transit )
    
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
