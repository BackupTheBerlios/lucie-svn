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
  
  # @name ‚Ì getter ‚ðƒeƒXƒg
  public
  def test_name_getter
    question = Deft::Question.new( 'OVERVIEW' )
    assert_equal( 'OVERVIEW', question.name )
  end
  
  # “o˜^‚³‚ê‚Ä‚¢‚é Question ‚ª‹ó‚Ì‚Æ‚«‚ÉA
  # question_defined? ‚ª nil ‚ð•Ô‚·‚±‚Æ‚ðŠm”F
  public
  def test_question_defined_fail
    Deft::Question.clear
    assert_nil( Deft::Question.question_defined?( 'NOT DEFINED QUESTION' ), 
                '“o˜^‚³‚ê‚Ä‚¢‚È‚¢‚Í‚¸‚ÌŽ¿–â€–Ú‚ª‚ ‚é' )
  end
  
  # Question ‚ð“o˜^‚µAquestion_defined? ‚Å“o˜^‚ªŠm”F‚Å‚«‚é‚±‚Æ‚ðƒeƒXƒg
  public
  def test_template_defined_success
    Deft::Question.clear
    question( 'TEST/QUESTION' )
    assert( Deft::Question.question_defined?( 'TEST/QUESTION' ), 'Ž¿–â€–Ú‚ª“o˜^‚³‚ê‚Ä‚¢‚È‚¢' )
  end
  
  # lookup ‚ÌƒeƒXƒg
  public
  def test_lookup_unknown_question
    question = Deft::Question::lookup( 'UNKNOWN QUESTION' )
    assert_kind_of( Deft::Question, question, 'question ‚ÌŒ^‚ªˆá‚¤' )
    assert_equal( 'UNKNOWN QUESTION', question.name, 'question ‚Ì–¼‘O‚ªˆá‚¤' )
  end
  
  # lookup ‚ÌƒeƒXƒg (‚ ‚ç‚©‚¶‚ß“o˜^‚µ‚½ Question ‚ðƒ‹ƒbƒNƒAƒbƒv)
  public
  def test_lookup_known_question
    Deft::Question::QUESTIONS['KNOWN QUESTION'] = Deft::Question.new('KNOWN QUESTION')
    question = Deft::Question::lookup( 'KNOWN QUESTION' )
    assert_kind_of( Deft::Question, question, 'question ‚ÌŒ^‚ªˆá‚¤' )
    assert_equal( 'KNOWN QUESTION', question.name, 'question ‚Ì–¼‘O‚ªˆá‚¤' )
  end
  
  public
  def test_enhance
    question = Deft::Question::new( 'TEST/QUESTION' )
    question.enhance do 
      # DO NOTHING
    end
    assert_equal( 1, question.actions.size, 'ƒAƒNƒVƒ‡ƒ“‚Ì”‚ªˆá‚¤' )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
