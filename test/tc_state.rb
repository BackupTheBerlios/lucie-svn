#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'lucie/state'
require 'test/unit'

class TC_State < Test::Unit::TestCase
  # �萔�̃e�X�g
  public 
  def test_PRIORITY_LOW
    assert_match /\A\S+\Z/, State::PRIORITY_LOW, "PRIORITY_LOW �萔����������`����Ă��Ȃ�����"
  end
  
  # �萔�̃e�X�g  
  public 
  def test_PRIORITY_MEDIUM
    assert_match /\A\S+\Z/, State::PRIORITY_MEDIUM, "PRIORITY_MEDIUM �萔����������`����Ă��Ȃ�����"
  end
  
  # �萔�̃e�X�g  
  public 
  def test_PRIORITY_HIGH
    assert_match /\A\S+\Z/, State::PRIORITY_HIGH, "PRIORITY_HIGH �萔����������`����Ă��Ȃ�����"
  end
  
  # �萔�̃e�X�g  
  public 
  def test_PRIORITY_CRITICAL
    assert_match /\A\S+\Z/, State::PRIORITY_CRITICAL, "PRIORITY_CRITICAL �萔����������`����Ă��Ȃ�����"
  end
  
  # transit ���\�b�h���A�u�X�g���N�g�ł��邱�Ƃ��m�F
  public
  def test_transit_not_implemented
    assert_raises( NotImplementedError, "NotImplementedError �� raise ����Ȃ�����" ) do
      State.new( "DUMMY STATE", State::PRIORITY_LOW ).transit nil
    end
  end
  
  # marshal ���\�b�h���A�u�X�g���N�g�ł��邱�Ƃ��m�F
  public
  def test_marshal_not_implemented
    assert_raises( NotImplementedError, "NotImplementedError �� raise ����Ȃ�����" ) do
      State::marshal nil
    end
  end
  
  # priority �Ƃ��Đ������Ȃ����̂�n�����Ƃ��� Exception ���m�F
  public
  def test_exception_with_unsupported_priority
    assert_raises( State::Exception::UnsupportedPriorityException, "State::Exception::UnsupportedPriorityException �� raise ����Ȃ�����" ) do
      State.new( "QUESTION", "UNSUPPORTED PRIORITY" )
    end
  end
  
  # question �Ƃ��ĕ������������Ƃ��� Exception ���m�F
  public
  def test_exception_with_invalid_type_of_question
    assert_raises( TypeError, "TypeError �� raise ����Ȃ�����" ) do
      State.new( nil, State::PRIORITY_LOW )
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
