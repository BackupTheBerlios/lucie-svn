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
  # @name ‚Ì getter ‚ðƒeƒXƒg
  public
  def test_name_getter
    question = Lucie::Question.new( 'OVERVIEW' )
    assert_equal 'OVERVIEW', question.name
  end
  
  # “o˜^‚³‚ê‚Ä‚¢‚é Question ‚ª‹ó‚Ì‚Æ‚«‚ÉA
  # question_defined? ‚ª nil ‚ð•Ô‚·‚±‚Æ‚ðŠm”F
  public
  def test_question_defined_fail
    Lucie::Question.clear
    assert_nil Lucie::Question.question_defined?( 'NOT DEFINED QUESTION' ), '“o˜^‚³‚ê‚Ä‚¢‚È‚¢‚Í‚¸‚ÌŽ¿–â€–Ú‚ª‚ ‚é'
  end
  
  # Question ‚ð“o˜^‚µAquestion_defined? ‚Å“o˜^‚ªŠm”F‚Å‚«‚é‚±‚Æ‚ðƒeƒXƒg
  public
  def test_template_defined_success
    Lucie::Question.clear
    question( 'TEST QUESTION' )
    assert Lucie::Question.question_defined?( 'TEST QUESTION' ), 'Ž¿–â€–Ú‚ª“o˜^‚³‚ê‚Ä‚¢‚È‚¢'
  end
  
  # lookup ‚ÌƒeƒXƒg
  public
  def test_lookup_unknown_question
    question = Lucie::Question::lookup( 'UNKNOWN QUESTION' )
    assert_kind_of Lucie::Question, question
    assert_equal 'UNKNOWN QUESTION', question.name
  end
  
  # lookup ‚ÌƒeƒXƒg (‚ ‚ç‚©‚¶‚ß“o˜^‚µ‚½ Question ‚ðƒ‹ƒbƒNƒAƒbƒv)
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
  
  # question ‚ð register ‚µA³‚µ‚­“o˜^‚³‚ê‚Ä‚¢‚é‚±‚Æ‚ðŠm”FB
  public
  def test_register
    question = Lucie::Question::new( 'TEST QUESTION' )
    question.enhance do |question|
      question.priority = Lucie::Question::PRIORITY_MEDIUM
      question.template = 'LUCIE/OVERVIEW'
      question.first_question = true
    end
    question.register
    
    assert_equal Lucie::Question::PRIORITY_MEDIUM, question.priority, 'priority ‚ª³‚µ‚­Ý’è‚³‚ê‚Ä‚¢‚È‚¢'
    assert_equal 'LUCIE/OVERVIEW', question.template, 'template ‚ª³‚µ‚­Ý’è‚³‚ê‚Ä‚¢‚È‚¢'
    assert question.first_question, 'first_question ‚ª³‚µ‚­Ý’è‚³‚ê‚Ä‚¢‚È‚¢'
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
