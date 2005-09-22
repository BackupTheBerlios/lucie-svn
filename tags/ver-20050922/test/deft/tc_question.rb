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
  
  public
  def teardown
    Deft::Question.clear
  end
  
  public
  def test_self_questions
    question( 'FOO' )
    assert_equal 1, Deft::Question.questions.size
    assert_kind_of Deft::Question, Deft::Question.questions[0]
    assert_equal 'FOO', Deft::Question.questions[0].name
  end

  public
  def test_self_hashaccess
    question( 'FOO' )
    assert_kind_of Deft::Question, Deft::Question['FOO']
    assert_equal 'FOO', Deft::Question['FOO'].name
  end
  
  # @name �� getter ��ƥ���
  public
  def test_name_getter
    question = Deft::Question.new( 'OVERVIEW' )
    assert_equal( 'OVERVIEW', question.name )
  end
  
  # ��Ͽ����Ƥ��� Question �����ΤȤ��ˡ�
  # question_defined? �� nil ���֤����Ȥ��ǧ
  public
  def test_question_defined_fail
    Deft::Question.clear
    assert_nil( Deft::Question.question_defined?( 'NOT DEFINED QUESTION' ), 
                '��Ͽ����Ƥ��ʤ��Ϥ��μ�����ܤ�����' )
  end
  
  # Question ����Ͽ����question_defined? ����Ͽ����ǧ�Ǥ��뤳�Ȥ�ƥ���
  public
  def test_template_defined_success
    Deft::Question.clear
    question( 'TEST/QUESTION' )
    assert( Deft::Question.question_defined?( 'TEST/QUESTION' ),
            '������ܤ���Ͽ����Ƥ��ʤ�' )
  end
  
  # lookup �Υƥ���
  public
  def test_lookup_unknown_question
    question = Deft::Question::lookup( 'UNKNOWN QUESTION' )
    assert_kind_of( Deft::Question, question, 'question �η����㤦' )
    assert_equal( 'UNKNOWN QUESTION', question.name, 'question ��̾�����㤦' )
  end
  
  # lookup �Υƥ��� (���餫������Ͽ���� Question ���å����å�)
  public
  def test_lookup_known_question
    Deft::Question::QUESTIONS['KNOWN QUESTION'] = Deft::Question.new('KNOWN QUESTION')
    question = Deft::Question::lookup( 'KNOWN QUESTION' )
    assert_kind_of( Deft::Question, question, 'question �η����㤦' )
    assert_equal( 'KNOWN QUESTION', question.name, 'question ��̾�����㤦' )
  end
  
  public
  def test_enhance
    question = Deft::Question::new( 'TEST/QUESTION' )
    question.enhance do 
      # DO NOTHING
    end
    assert_equal( 1, question.actions.size, '���������ο����㤦' )
  end

  public
  def test_InvalidQuestionName_raised
    assert_raises( Deft::Exception::InvalidQuestionNameException ) do 
      question( nil )
    end
  end

  public
  def test_InvalidNextQuestionType_raised
    assert_raises( Deft::Exception::InvalidNextQuestionTypeException ) do
      question( 'FOO' => 1 )
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
