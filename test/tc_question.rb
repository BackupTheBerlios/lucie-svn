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
  # @name の getter をテスト
  public
  def test_name_getter
    question = Lucie::Question.new( 'OVERVIEW' )
    assert_equal 'OVERVIEW', question.name
  end
  
  # 登録されている Question が空のときに、
  # question_defined? が nil を返すことを確認
  public
  def test_question_defined_fail
    Lucie::Question.clear
    assert_nil Lucie::Question.question_defined?( 'NOT DEFINED QUESTION' ), '登録されていないはずの質問項目がある'
  end
  
  # Question を登録し、question_defined? で登録が確認できることをテスト
  public
  def test_template_defined_success
    Lucie::Question.clear
    question( 'TEST QUESTION' )
    assert Lucie::Question.question_defined?( 'TEST QUESTION' ), '質問項目が登録されていない'
  end
  
  # lookup のテスト
  public
  def test_lookup_unknown_question
    question = Lucie::Question::lookup( 'UNKNOWN QUESTION' )
    assert_kind_of Lucie::Question, question
    assert_equal 'UNKNOWN QUESTION', question.name
  end
  
  # lookup のテスト (あらかじめ登録した Question をルックアップ)
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
  
  # question を register し、正しく登録されていることを確認。
  public
  def test_register
    question = Lucie::Question::new( 'TEST QUESTION' )
    question.enhance do |question|
      question.priority = Lucie::Question::PRIORITY_MEDIUM
      question.template = 'LUCIE/OVERVIEW'
      question.first_question = true
    end
    question.register
    
    assert_equal Lucie::Question::PRIORITY_MEDIUM, question.priority, 'priority が正しく設定されていない'
    assert_equal 'LUCIE/OVERVIEW', question.template, 'template が正しく設定されていない'
    assert question.first_question, 'first_question が正しく設定されていない'
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
