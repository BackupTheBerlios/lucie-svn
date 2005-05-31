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

  # to_s で Deft::Exception::RequiredAttributeException が raise されることをテスト
  # short/extended description が揃っていない場合には上記例外が raise される。
  public
  def test_to_s_raises_required_attribute_exception
    assert_raises( Deft::Exception::RequiredAttributeException,
                   "Deft::Exception::RequiredAttributeException が raise されなかった" ) do
      @boolean_template.to_s
    end

    # extended が無いので例外発生
    @boolean_template.short_description = 'TEST SHORT DESCRIPTION'
    @boolean_template.extended_description = nil
    @boolean_template.short_description_ja = nil
    @boolean_template.extended_description_ja = nil
    assert_raises( Deft::Exception::RequiredAttributeException,
                   "Deft::Exception::RequiredAttributeException が raise されなかった" ) do
      @boolean_template.to_s
    end

    # short/extended が揃っているので例外は発生しない
    @boolean_template.short_description = 'TEST SHORT DESCRIPTION'
    @boolean_template.extended_description = 'TEST EXTENDED DESCRIPTION'
    @boolean_template.short_description_ja = nil
    @boolean_template.extended_description_ja = nil
    begin
      @boolean_template.to_s
    rescue
      fail "to_s で予期しない例外が raise された"
    end

    # extended..._ja が無いので例外発生
    @boolean_template.short_description = nil
    @boolean_template.extended_description = nil
    @boolean_template.short_description_ja = 'TEST SHORT DESCRIPTION JA'
    @boolean_template.extended_description_ja = nil
    assert_raises( Deft::Exception::RequiredAttributeException,
                   "Deft::Exception::RequiredAttributeException が raise されなかった" ) do
      @boolean_template.to_s
    end

    # short..._ja/extended..._ja が揃っているので例外は発生しない
    @boolean_template.short_description = nil
    @boolean_template.extended_description = nil
    @boolean_template.short_description_ja = 'TEST SHORT DESCRIPTION JA'
    @boolean_template.extended_description_ja = 'TEST EXTENDED DESCRIPTION JA'
    begin
      @boolean_template.to_s
    rescue
      fail "to_s で予期しない例外が raise された"
    end
  end
  
  # @choices= が Deft::Exception::InvalidAttributeException を返すことをテスト
  public 
  def test_setter_choices_raises_invalid_attribute_exception
    assert_raises( Deft::Exception::InvalidAttributeException, 
                   '@choices への代入で InvalidAttributeException が raise されなかった' ) do 
      @boolean_template.choices = 'THIS MUST RAISE EXCEPTION'
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
