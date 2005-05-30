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
    Deft::Template.clear
  end
  
  public
  def teardown
    Deft::Template.clear
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
  
  public
  def test_register
    template = template( 'TEST/BOOLEAN-TEMPLATE' ) do |template|
      template.template_type = 'boolean'
      template.default = 'true'
      template.short_description = 'This is a short description'
      template.extended_description = 'This is a extended description'
      template.short_description_ja = 'これは短いデスクリプションです'
      template.extended_description_ja = 'これは長いデスクリプションです'      
    end
    assert_equal( 'TEST/BOOLEAN-TEMPLATE', template.name,
                  'name アトリビュートの値が正しくない' )
    assert_equal( 'boolean', template.template_type,
                  'template_type アトリビュートの値が正しくない' )
    assert_equal( 'true', template.default,
                  'default アトリビュートの値が正しくない' )
    assert_equal( 'This is a short description', template.short_description,
                  'short_description アトリビュートの値が正しくない' )
    assert_equal( 'This is a extended description', template.extended_description,
                  'extended_description アトリビュートの値が正しくない' ) 
    assert_equal( 'これは短いデスクリプションです', template.short_description_ja,
                  'short_description_ja アトリビュートの値が正しくない' ) 
    assert_equal( 'これは長いデスクリプションです', template.extended_description_ja,
                  'extended_description_ja アトリビュートの値が正しくない' )    
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
