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
  
  # @name の getter をテスト
  public
  def test_name_getter
    question = Deft::Question.new( 'OVERVIEW' )
    assert_equal( 'OVERVIEW', question.name )
  end
  
  # 登録されている Question が空のときに、
  # question_defined? が nil を返すことを確認
  public
  def test_question_defined_fail
    Deft::Question.clear
    assert_nil( Deft::Question.question_defined?( 'NOT DEFINED QUESTION' ), 
                '登録されていないはずの質問項目がある' )
  end
  
  # Question を登録し、question_defined? で登録が確認できることをテスト
  public
  def test_template_defined_success
    Deft::Question.clear
    question( 'TEST/QUESTION' )
    assert( Deft::Question.question_defined?( 'TEST/QUESTION' ),
            '質問項目が登録されていない' )
  end
  
  # lookup のテスト
  public
  def test_lookup_unknown_question
    question = Deft::Question::lookup( 'UNKNOWN QUESTION' )
    assert_kind_of( Deft::Question, question, 'question の型が違う' )
    assert_equal( 'UNKNOWN QUESTION', question.name, 'question の名前が違う' )
  end
  
  # lookup のテスト (あらかじめ登録した Question をルックアップ)
  public
  def test_lookup_known_question
    Deft::Question::QUESTIONS['KNOWN QUESTION'] = Deft::Question.new('KNOWN QUESTION')
    question = Deft::Question::lookup( 'KNOWN QUESTION' )
    assert_kind_of( Deft::Question, question, 'question の型が違う' )
    assert_equal( 'KNOWN QUESTION', question.name, 'question の名前が違う' )
  end
  
  public
  def test_enhance
    question = Deft::Question::new( 'TEST/QUESTION' )
    question.enhance do 
      # DO NOTHING
    end
    assert_equal( 1, question.actions.size, 'アクションの数が違う' )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
