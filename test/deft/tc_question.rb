#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'deft/question'
require 'test/unit'

class TC_Question < Test::Unit::TestCase
  public
  def setup
    Deft::Question.clear
  end
  
  # @name �� getter ���e�X�g
  public
  def test_name_getter
    question = Deft::Question.new( 'OVERVIEW' )
    assert_equal( 'OVERVIEW', question.name )
  end
  
  # �o�^����Ă��� Question ����̂Ƃ��ɁA
  # question_defined? �� nil ��Ԃ����Ƃ��m�F
  public
  def test_question_defined_fail
    Deft::Question.clear
    assert_nil( Deft::Question.question_defined?( 'NOT DEFINED QUESTION' ), 
                '�o�^����Ă��Ȃ��͂��̎��⍀�ڂ�����' )
  end
  
  # Question ��o�^���Aquestion_defined? �œo�^���m�F�ł��邱�Ƃ��e�X�g
  public
  def test_template_defined_success
    Deft::Question.clear
    question( 'TEST/QUESTION' )
    assert( Deft::Question.question_defined?( 'TEST/QUESTION' ), '���⍀�ڂ��o�^����Ă��Ȃ�' )
  end
  
  # lookup �̃e�X�g
  public
  def test_lookup_unknown_question
    question = Deft::Question::lookup( 'UNKNOWN QUESTION' )
    assert_kind_of( Deft::Question, question, 'question �̌^���Ⴄ' )
    assert_equal( 'UNKNOWN QUESTION', question.name, 'question �̖��O���Ⴄ' )
  end
  
  # lookup �̃e�X�g (���炩���ߓo�^���� Question �����b�N�A�b�v)
  public
  def test_lookup_known_question
    Deft::Question::QUESTIONS['KNOWN QUESTION'] = Deft::Question.new('KNOWN QUESTION')
    question = Deft::Question::lookup( 'KNOWN QUESTION' )
    assert_kind_of( Deft::Question, question, 'question �̌^���Ⴄ' )
    assert_equal( 'KNOWN QUESTION', question.name, 'question �̖��O���Ⴄ' )
  end
  
  public
  def test_enhance
    question = Deft::Question::new( 'TEST/QUESTION' )
    question.enhance do 
      # DO NOTHING
    end
    assert_equal( 1, question.actions.size, '�A�N�V�����̐����Ⴄ' )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
