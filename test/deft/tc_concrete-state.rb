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
    assert_equal( [], Deft::ConcreteState.states, '�f�t�H���g�� Concrete State ����łȂ�' )
  end
  
  public
  def test00_lookup_returns_nil
    assert_nil( Deft::ConcreteState[ 'CONCRETE STATE NAME' ], 'nil ���Ԃ�͂������Ԃ�Ȃ�' )
  end
  
  public
  def test00_first_state_returns_nil
    assert_nil( Deft::ConcreteState.first_state, 'nil ���Ԃ�͂������Ԃ�Ȃ�' )
  end
  
  public
  def test01_concrete_state
    define_templates_and_questions
    assert_equal( 3, Deft::ConcreteState.states.size, '�o�^����Ă��� Concrete State �̐����Ⴄ' )
  end
  
  public
  def test02_lookup
    assert_equal( 'Deft::State::Test__Template1', Deft::ConcreteState['TEST/TEMPLATE1'].class.to_s,
                  "Concrete State `TEST/TEMPLATE1' �����O�ň����Ȃ�" )
  end
  
  public
  def test03_lookup
    assert_equal( 'Deft::State::Test__Template2', Deft::ConcreteState['TEST/TEMPLATE2'].class.to_s,
                  "Concrete State `TEST/TEMPLATE2' �����O�ň����Ȃ�" )
  end
  
  public
  def test04_lookup
    assert_equal( 'Deft::State::Test__Template3', Deft::ConcreteState['TEST/TEMPLATE3'].class.to_s,
                  "Concrete State `TEST/TEMPLATE3' �����O�ň����Ȃ�" )
  end
  
  private
  def define_templates_and_questions
    template( 'TEST/TEMPLATE1' ) do |template|
      template.template_type = Deft::NoteTemplate
      template.short_description_ja = '�e�X�g�e���v���[�g�P'
      template.extended_description_ja = (<<-DESCRIPTION_JA)
      �e�X�g�e���v���[�g�P�ł��B
      DESCRIPTION_JA
    end    
    question( 'TEST/TEMPLATE1' ) do |question|
      question.priority = Deft::Question::PRIORITY_MEDIUM
      question.next_question = 'TEST/TEMPLATE2'
      question.first_question = true
    end
    
    template( 'TEST/TEMPLATE2' ) do |template|
      template.template_type = Deft::NoteTemplate
      template.short_description_ja = '�e�X�g�e���v���[�g�Q'
      template.extended_description_ja = (<<-DESCRIPTION_JA)
      �e�X�g�e���v���[�g�Q�ł��B
      DESCRIPTION_JA
    end    
    question( 'TEST/TEMPLATE2' ) do |question|
      question.priority = Deft::Question::PRIORITY_MEDIUM
      question.next_question = 'TEST/TEMPLATE3'
    end
    
    template( 'TEST/TEMPLATE3' ) do |template|
      template.template_type = Deft::NoteTemplate
      template.short_description_ja = '�e�X�g�e���v���[�g�R'
      template.extended_description_ja = (<<-DESCRIPTION_JA)
      �e�X�g�e���v���[�g�R�ł��B
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
