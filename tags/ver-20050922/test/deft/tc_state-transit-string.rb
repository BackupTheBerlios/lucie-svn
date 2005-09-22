#
# $Id: tc_state-transit-hash-state.rb 859 2005-09-14 06:15:58Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 859 $
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'deft/debconf-context'
require 'deft/question'
require 'deft/state'
require 'mock'
require 'test/unit'

class TC_StateTransitStringState < Test::Unit::TestCase

  #
  # テスト用 debconf 定義
  #
  #    START (note) ----------> END (note)
  #
  public
  def setup
    clear_debconf_definition
    template( 'START' ) do |template|
      template.template_type = 'note'
      template.short_description_ja = 'スタート'
      template.extended_description_ja = 'スタート'
    end    
    question( 'START' => 'END' ) do |question|
      question.priority = Deft::Question::PRIORITY_MEDIUM
      question.first_question = true
    end
    
    template( 'END' ) do |template|
      template.template_type = 'note'
      template.short_description_ja = 'END'
      template.extended_description_ja = 'END'
    end    
    question( 'END' ) do |question|
      question.priority = Deft::Question::PRIORITY_MEDIUM
    end     
    
    @debconf_context = Deft::DebconfContext.new
  end
  
  public
  def teardown
    clear_debconf_definition
  end
  
  # 
  #   CLIENT        DEBCONF
  #   
  #   -------------------->
  #   'INPUT medium START'
  #
  #   <--------------------
  #            '0'
  #
  #   -------------------->
  #            'GO'
  #
  #   <--------------------
  #            '0'
  #
  public
  def test_transit_to_END
    $stdout_mock = Mock.new( '#<STDOUT (Mock)>' )
    $stdin_mock = Mock.new( '#<STDIN (Mock)>' )
    $stdout_mock.__next( :print ) do |argument| 
      assert_equal( "INPUT medium START\n", argument ) 
    end
    $stdin_mock.__next( :gets ) do '0' end    
    $stdout_mock.__next( :print ) do |argument| 
      assert_equal( "GO\n", argument ) 
    end    
    $stdin_mock.__next( :gets ) do '0' end
        
    @debconf_context.transit
    assert_equal( Deft::ConcreteState['END'], @debconf_context.current_state )
    
    $stdout_mock.__verify
    $stdin_mock.__verify
  end 

  # 
  #   CLIENT        DEBCONF
  #   
  #   -------------------->
  #   'INPUT medium START'
  #
  #   <--------------------
  #            '0'
  #
  #   -------------------->
  #            'GO'
  #
  #   <--------------------
  #            '30'
  #
  public
  def test_debconf_returns_30
    $stdout_mock = Mock.new( '#<STDOUT (Mock)>' )
    $stdin_mock = Mock.new( '#<STDIN (Mock)>' )
    $stdout_mock.__next( :print ) do |argument| 
      assert_equal( "INPUT medium START\n", argument ) 
    end
    $stdin_mock.__next( :gets ) do '0' end    
    $stdout_mock.__next( :print ) do |argument| 
      assert_equal( "GO\n", argument ) 
    end    
    $stdin_mock.__next( :gets ) do '30' end

    @debconf_context.transit
    assert_equal( Deft::ConcreteState['START'], @debconf_context.current_state )

    $stdout_mock.__verify
    $stdin_mock.__verify
  end
   
  private
  def clear_debconf_definition
    Deft::Template.clear
    Deft::Question.clear
    Deft::ConcreteState.clear
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
