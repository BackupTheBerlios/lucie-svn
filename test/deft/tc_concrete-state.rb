#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'deft'
require 'deft/concrete-state'
require 'test/unit'

class TC_ConcreteState < Test::Unit::TestCase
  public
  def test00_default_state
    assert_equal( [], Deft::ConcreteState.states, 'デフォルトの Concrete State が空でない' )
  end
  
  public
  def test00_lookup_returns_nil
    assert_nil( Deft::ConcreteState[ 'CONCRETE STATE NAME' ], 'nil が返るはずだが返らない' )
  end
  
  public
  def test00_first_state_returns_nil
    assert_nil( Deft::ConcreteState.first_state, 'nil が返るはずだが返らない' )
  end
  
  public
  def test01_concrete_state
    define_templates_and_questions
    assert_equal( 3, Deft::ConcreteState.states.size, '登録されている Concrete State の数が違う' )
  end
  
  public
  def test02_lookup
    assert_equal( 'Deft::State::Test__Template1', Deft::ConcreteState['TEST/TEMPLATE1'].class.to_s,
                  "Concrete State `TEST/TEMPLATE1' が名前で引けない" )
  end
  
  public
  def test03_lookup
    assert_equal( 'Deft::State::Test__Template2', Deft::ConcreteState['TEST/TEMPLATE2'].class.to_s,
                  "Concrete State `TEST/TEMPLATE2' が名前で引けない" )
  end
  
  public
  def test04_lookup
    assert_equal( 'Deft::State::Test__Template3', Deft::ConcreteState['TEST/TEMPLATE3'].class.to_s,
                  "Concrete State `TEST/TEMPLATE3' が名前で引けない" )
  end
  
  private
  def define_templates_and_questions
    template( 'TEST/TEMPLATE1' ) do |template|
      template.template_type = Deft::NoteTemplate
      template.short_description_ja = 'テストテンプレート１'
      template.extended_description_ja = (<<-DESCRIPTION_JA)
      テストテンプレート１です。
      DESCRIPTION_JA
    end    
    question( 'TEST/TEMPLATE1' ) do |question|
      question.priority = Deft::Question::PRIORITY_MEDIUM
      question.next_question = 'TEST/TEMPLATE2'
      question.first_question = true
    end
    
    template( 'TEST/TEMPLATE2' ) do |template|
      template.template_type = Deft::NoteTemplate
      template.short_description_ja = 'テストテンプレート２'
      template.extended_description_ja = (<<-DESCRIPTION_JA)
      テストテンプレート２です。
      DESCRIPTION_JA
    end    
    question( 'TEST/TEMPLATE2' ) do |question|
      question.priority = Deft::Question::PRIORITY_MEDIUM
      question.next_question = 'TEST/TEMPLATE3'
    end
    
    template( 'TEST/TEMPLATE3' ) do |template|
      template.template_type = Deft::NoteTemplate
      template.short_description_ja = 'テストテンプレート３'
      template.extended_description_ja = (<<-DESCRIPTION_JA)
      テストテンプレート３です。
      DESCRIPTION_JA
    end    
    question( 'TEST/TEMPLATE3' ) do |question|
      question.priority = Deft::Question::PRIORITY_MEDIUM
    end    
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
