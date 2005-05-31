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
  
  # to_s で templates 文字列が正しく生成されることをテスト
  #--
  # TODO: default= の引数チェック (yes/no だけ受け付ける)
  #++ 
  public
  def test_to_s
    @boolean_template.default = 'yes'
    @boolean_template.short_description = 'TEST SHORT DESCRIPTION'
    @boolean_template.extended_description = 'TEST EXTENDED DESCRIPTION'
    @boolean_template.short_description_ja = 'TEST SHORT DESCRIPTION JA'
    @boolean_template.extended_description_ja = 'TEST EXTENDED DESCRIPTION JA'
    assert_equal( (<<-BOOLEAN_TEMPLATE).chomp, @boolean_template.to_s, "to_s が正しい値を返さない" )
Template: TEST BOOLEAN TEMPLATE
Type: boolean
Default: yes
Description: TEST SHORT DESCRIPTION
 TEST EXTENDED DESCRIPTION
Description-ja: TEST SHORT DESCRIPTION JA
 TEST EXTENDED DESCRIPTION JA
   BOOLEAN_TEMPLATE
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
