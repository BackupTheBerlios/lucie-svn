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
  # 定数のテスト
  public 
  def test_PRIORITY_LOW
    assert_match /\A\S+\Z/, State::PRIORITY_LOW, "PRIORITY_LOW 定数が正しく定義されていなかった"
  end
  
  # 定数のテスト  
  public 
  def test_PRIORITY_MEDIUM
    assert_match /\A\S+\Z/, State::PRIORITY_MEDIUM, "PRIORITY_MEDIUM 定数が正しく定義されていなかった"
  end
  
  # 定数のテスト  
  public 
  def test_PRIORITY_HIGH
    assert_match /\A\S+\Z/, State::PRIORITY_HIGH, "PRIORITY_HIGH 定数が正しく定義されていなかった"
  end
  
  # 定数のテスト  
  public 
  def test_PRIORITY_CRITICAL
    assert_match /\A\S+\Z/, State::PRIORITY_CRITICAL, "PRIORITY_CRITICAL 定数が正しく定義されていなかった"
  end
  
  # transit メソッドがアブストラクトであることを確認
  public
  def test_transit_not_implemented
    assert_raises( NotImplementedError, "NotImplementedError が raise されなかった" ) do
      State.new( "DUMMY STATE", State::PRIORITY_LOW ).transit nil
    end
  end
  
  # marshal メソッドがアブストラクトであることを確認
  public
  def test_marshal_not_implemented
    assert_raises( NotImplementedError, "NotImplementedError が raise されなかった" ) do
      State::marshal nil
    end
  end
  
  # priority として正しくないものを渡したときの Exception を確認
  public
  def test_exception_with_unsupported_priority
    assert_raises( State::Exception::UnsupportedPriorityException, "State::Exception::UnsupportedPriorityException が raise されなかった" ) do
      State.new( "QUESTION", "UNSUPPORTED PRIORITY" )
    end
  end
  
  # question として方がおかしいときの Exception を確認
  public
  def test_exception_with_invalid_type_of_question
    assert_raises( TypeError, "TypeError が raise されなかった" ) do
      State.new( nil, State::PRIORITY_LOW )
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
