#
# $Id: tc_boolean-template.rb 628 2005-05-31 09:55:09Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 628 $
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'deft/boolean-template'
require 'deft/multiselect-template'
require 'deft/note-template'
require 'deft/password-template'
require 'deft/select-template'
require 'deft/string-template'
require 'deft/text-template'
require 'test/unit'

class RequiredAttributeExceptionTest < Test::Unit::TestCase
  # short/extended description が揃っていない場合の 
  # Deft::Exception::RequiredAttributeException をテスト
  public
  def description_test( aTemplate )
    assert_raises( Deft::Exception::RequiredAttributeException,
                   "Deft::Exception::RequiredAttributeException が raise されなかった" ) do
      aTemplate.to_s
    end

    # extended が無いので例外発生
    aTemplate.short_description = 'TEST SHORT DESCRIPTION'
    aTemplate.extended_description = nil
    aTemplate.short_description_ja = nil
    aTemplate.extended_description_ja = nil
    assert_raises( Deft::Exception::RequiredAttributeException,
                   "Deft::Exception::RequiredAttributeException が raise されなかった" ) do
      aTemplate.to_s
    end

    # short/extended が揃っているので例外は発生しない
    aTemplate.short_description = 'TEST SHORT DESCRIPTION'
    aTemplate.extended_description = 'TEST EXTENDED DESCRIPTION'
    aTemplate.short_description_ja = nil
    aTemplate.extended_description_ja = nil
    begin
      aTemplate.to_s
    rescue
      fail "to_s で予期しない例外が raise された"
    end

    # extended..._ja が無いので例外発生
    aTemplate.short_description = nil
    aTemplate.extended_description = nil
    aTemplate.short_description_ja = 'TEST SHORT DESCRIPTION JA'
    aTemplate.extended_description_ja = nil
    assert_raises( Deft::Exception::RequiredAttributeException,
                   "Deft::Exception::RequiredAttributeException が raise されなかった" ) do
      aTemplate.to_s
    end

    # short..._ja/extended..._ja が揃っているので例外は発生しない
    aTemplate.short_description = nil
    aTemplate.extended_description = nil
    aTemplate.short_description_ja = 'TEST SHORT DESCRIPTION JA'
    aTemplate.extended_description_ja = 'TEST EXTENDED DESCRIPTION JA'
    begin
      aTemplate.to_s
    rescue
      fail "to_s で予期しない例外が raise された"
    end
  end

  # 'No tests were specified' を避けるためのメソッド
  public
  def test_dummy
    # do nothing
  end
end

# string テンプレートでのテスト
class TC_StringTemplateRequiredAttributeException < RequiredAttributeExceptionTest
  public
  def test_required_attribute_exception
    string_template = Deft::StringTemplate.new( 'TEST STRING TEMPLATE' )
    description_test( string_template )
  end
end

# boolean テンプレートでのテスト
class TC_BooleanTemplateRequiredAttributeException < RequiredAttributeExceptionTest
  public
  def test_required_attribute_exception
    boolean_template = Deft::BooleanTemplate.new( 'TEST BOOLEAN TEMPLATE' )
    description_test( boolean_template )
  end
end

# select テンプレートでのテスト
class TC_SelectTemplateRequiredAttributeException < RequiredAttributeExceptionTest
  public
  def test_required_attribute_exception
    select_template = Deft::SelectTemplate.new( 'TEST SELECT TEMPLATE' )
    description_test( select_template )
  end
end

# multiselect テンプレートでのテスト
class TC_MultiselectTemplateRequiredAttributeException < RequiredAttributeExceptionTest
  public
  def test_required_attribute_exception
    multiselect_template = Deft::MultiselectTemplate.new( 'TEST MULTISELECT TEMPLATE' )
    description_test( multiselect_template )
  end
end

# note テンプレートでのテスト
class TC_NoteTemplateRequiredAttributeException < RequiredAttributeExceptionTest
  public
  def test_required_attribute_exception
    note_template = Deft::NoteTemplate.new( 'TEST NOTE TEMPLATE' )
    description_test( note_template )
  end
end

# text テンプレートでのテスト
class TC_TextTemplateRequiredAttributeException < RequiredAttributeExceptionTest
  public
  def test_required_attribute_exception
    text_template = Deft::TextTemplate.new( 'TEST TEXT TEMPLATE' )
    description_test( text_template )
  end
end

# password テンプレートでのテスト
class TC_PasswordTemplateRequiredAttributeException < RequiredAttributeExceptionTest
  public
  def test_required_attribute_exception
    password_template = Deft::PasswordTemplate.new( 'TEST PASSWORD TEMPLATE' )
    description_test( password_template )
  end
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:

