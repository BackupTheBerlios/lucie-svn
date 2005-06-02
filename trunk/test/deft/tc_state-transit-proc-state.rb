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

class TC_StateTransitProcState < Test::Unit::TestCase
  public
  def setup
    clear
    
    template( 'start' ) do |template|
      template.template_type = 'note'
      template.short_description_ja = 'スタート'
      template.extended_description_ja = 'スタート'
    end    
    question( 'start' => proc do |user_input| 
      case user_input
      when 'true'
        'true'
      when 'false'
        'false'
      else
        'error'
      end
    end ) do |question|
      question.priority = Deft::Question::PRIORITY_MEDIUM
      question.first_question = true
    end
    
    template( 'true' ) do |template|
      template.template_type = 'note'
      template.short_description_ja = 'true'
      template.extended_description_ja = 'true'
    end    
    question( 'true' ) do |question|
      question.priority = Deft::Question::PRIORITY_MEDIUM
    end     
    template( 'false' ) do |template|
      template.template_type = 'note'
      template.short_description_ja = 'false'
      template.extended_description_ja = 'false'
    end    
    question( 'false' ) do |question|
      question.priority = Deft::Question::PRIORITY_MEDIUM
    end
    template( 'error' ) do |template|
      template.template_type = 'note'
      template.short_description_ja = 'error'
      template.extended_description_ja = 'error'
    end    
    question( 'error' ) do |question|
      question.priority = Deft::Question::PRIORITY_MEDIUM
    end
    
    @debconf_context = Deft::DebconfContext.new
  end
  
  public
  def teardown
    clear
  end
  
  public
  def test_transit_true
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
      assert_equal( "GET start\n", argument ) 
    end    
    $stdin_mock.__next( :gets ) do '0 true' end
        
    @debconf_context.transit
    assert_equal( Deft::ConcreteState['true'], 
                  @debconf_context.current_state )
    
    $stdout_mock.__verify
    $stdin_mock.__verify
  end 

  public
  def test_transit_false    
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
      assert_equal( "GET start\n", argument ) 
    end    
    $stdin_mock.__next( :gets ) do '0 false' end
        
    @debconf_context.transit
    assert_equal( Deft::ConcreteState['false'], 
                  @debconf_context.current_state )
    
    $stdout_mock.__verify
    $stdin_mock.__verify
  end
  
  public
  def test_transit_error    
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
      assert_equal( "GET start\n", argument ) 
    end    
    $stdin_mock.__next( :gets ) do '0 hoge' end
        
    @debconf_context.transit
    assert_equal( Deft::ConcreteState['error'], 
                  @debconf_context.current_state )
    
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
