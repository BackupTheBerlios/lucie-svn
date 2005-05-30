#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'deft/boolean-template'
require 'test/unit'

class TC_BooleanTemplate < Test::Unit::TestCase
  public
  def setup
    @boolean_template = Deft::BooleanTemplate.new( 'TEST BOOLEAN TEMPLATE' )
  end

  # template_type が 'boolean' を返すことをテスト
  #--
  # FIXME: このメソッドはなぜ必要？
  #++
  public
  def test_template_type
    assert_equal 'boolean', @boolean_template.template_type, "template_type が正しい値を返さない"
  end
  
  # @choices= が Deft::Exception::InvalidAttributeException を返すことをテスト
  public 
  def test_setter_choices_raises_invalid_attribute_exception
    assert_raises( Deft::Exception::InvalidAttributeException, 
                   '@choices への代入で InvalidAttributeException が raise されなかった' ) do 
      @boolean_template.choices = 'THIS MUST RAISE EXCEPTION'
    end
  end

  # inspect の返り値をテスト
  public
  def test_inspect
    assert_equal( %{#<Deft::BooleanTemplate: @name="TEST BOOLEAN TEMPLATE">},
                  @boolean_template.inspect, "inspect が正しい値を返さない" )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
