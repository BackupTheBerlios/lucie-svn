#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'lucie/question'
require 'test/unit'

class TC_Question < Test::Unit::TestCase
  # @name �� getter ���e�X�g
  public
  def test_name_getter
    question = Lucie::Question.new( 'OVERVIEW' )
    assert_equal 'OVERVIEW', question.name
  end
  
  # �o�^����Ă��� Question ����̂Ƃ��ɁA
  # question_defined? �� nil ��Ԃ����Ƃ��m�F
  public
  def test_question_defined_fail
    Lucie::Question.clear
    assert_nil Lucie::Question.question_defined?( 'NOT DEFINED QUESTION' ), '�o�^����Ă��Ȃ��͂��̎��⍀�ڂ�����'
  end
  
  # Question ��o�^���Aquestion_defined? �œo�^���m�F�ł��邱�Ƃ��e�X�g
  public
  def test_template_defined_success
    Lucie::Question.clear
    question( 'TEST QUESTION' )
    assert Lucie::Question.question_defined?( 'TEST QUESTION' ), '���⍀�ڂ��o�^����Ă��Ȃ�'
  end
  
  # lookup �̃e�X�g
  public
  def test_lookup_unknown_question
    question = Lucie::Question::lookup( 'UNKNOWN QUESTION' )
    assert_kind_of Lucie::Question, question
    assert_equal 'UNKNOWN QUESTION', question.name
  end
  
  # lookup �̃e�X�g (���炩���ߓo�^���� Question �����b�N�A�b�v)
  public
  def test_lookup_known_question
    Lucie::Question::QUESTIONS['KNOWN QUESTION'] = Lucie::Question.new('KNOWN QUESTION')
    question = Lucie::Question::lookup( 'KNOWN QUESTION' )
    assert_kind_of Lucie::Question, question
    assert_equal 'KNOWN QUESTION', question.name
  end
  
  public
  def test_enhance
    question = Lucie::Question::new( 'TEST QUESTION' )
    question.enhance do 
      # DO NOTHING
    end
    assert_equal 1, question.actions.size
  end
  
  # question �� register ���A�������o�^����Ă��邱�Ƃ��m�F�B
  public
  def test_register
    question = Lucie::Question::new( 'TEST QUESTION' )
    question.enhance do |question|
      question.priority = Lucie::Question::PRIORITY_MEDIUM
      question.template = 'LUCIE/OVERVIEW'
      question.first_question = true
    end
    question.register
    
    assert_equal Lucie::Question::PRIORITY_MEDIUM, question.priority, 'priority ���������ݒ肳��Ă��Ȃ�'
    assert_equal 'LUCIE/OVERVIEW', question.template, 'template ���������ݒ肳��Ă��Ȃ�'
    assert question.first_question, 'first_question ���������ݒ肳��Ă��Ȃ�'
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
