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
  #
  # テスト用 debconf 定義として、START state から yes/no によってそれ
  # ぞれの state に遷移するものを準備。
  #
  #
  #    START (string)
  #          |
  #        __|___
  #       |     |
  #  'yes'|     |'no'
  #       |     |
  #       v     v
  #      YES    NO
  #    (note)  (note)
  #
  # yes/no 以外は ERROR へ。
  #
  public
  def setup
    clear_debconf_definition
    
    template( 'START' ) do |template|
      template.template_type = 'string'
      template.short_description_ja = 'スタート'
      template.extended_description_ja = 'スタート'
    end    
    question( 'START' => proc do |user_input| 
      case user_input
      when 'yes'
        'YES'
      when 'no'
        'NO'
      else
        'ERROR'
      end
    end ) do |question|
      question.priority = Deft::Question::PRIORITY_MEDIUM
      question.first_question = true
    end
    
    template( 'YES' ) do |template|
      template.template_type = 'note'
      template.short_description_ja = 'YES'
      template.extended_description_ja = 'YES'
    end    
    question( 'YES' ) do |question|
      question.priority = Deft::Question::PRIORITY_MEDIUM
    end     
    template( 'NO' ) do |template|
      template.template_type = 'note'
      template.short_description_ja = 'NO'
      template.extended_description_ja = 'NO'
    end    
    question( 'NO' ) do |question|
      question.priority = Deft::Question::PRIORITY_MEDIUM
    end
    template( 'ERROR' ) do |template|
      template.template_type = 'note'
      template.short_description_ja = 'ERROR'
      template.extended_description_ja = 'ERROR'
    end    
    question( 'ERROR' ) do |question|
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
  #   -------------------->
  #        'GET START'
  #
  #   <--------------------
  #          '0 yes'
  #    
  public
  def test_transit_YES
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
    $stdout_mock.__next( :print ) do |argument| 
      assert_equal( "GET START\n", argument ) 
    end    
    $stdin_mock.__next( :gets ) do '0 yes' end
        
    @debconf_context.transit
    assert_equal( Deft::ConcreteState['YES'], 
                  @debconf_context.current_state )
    
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
  #            '0'
  #
  #   -------------------->
  #        'GET START'
  #
  #   <--------------------
  #          '0 no'
  #    
  public
  def test_transit_NO
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
    $stdout_mock.__next( :print ) do |argument| 
      assert_equal( "GET START\n", argument ) 
    end    
    $stdin_mock.__next( :gets ) do '0 no' end
        
    @debconf_context.transit
    assert_equal( Deft::ConcreteState['NO'], 
                  @debconf_context.current_state )
    
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
  #            '0'
  #
  #   -------------------->
  #        'GET START'
  #
  #   <--------------------
  #          '0 hoge'
  #    
  public
  def test_transit_error    
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
    $stdout_mock.__next( :print ) do |argument| 
      assert_equal( "GET START\n", argument ) 
    end    
    $stdin_mock.__next( :gets ) do '0 hoge' end
        
    @debconf_context.transit
    assert_equal( Deft::ConcreteState['ERROR'], 
                  @debconf_context.current_state )
    
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
