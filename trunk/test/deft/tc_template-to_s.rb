#
# $Id: tc_template-inspect.rb 625 2005-05-31 08:51:23Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 625 $
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'deft/template'
require 'test/unit'

# 各テンプレートクラスの to_s メソッドをテスト
class TC_TemplateString < Test::Unit::TestCase
  public
  def setup
    @text_template        = Deft::TextTemplate.new( 'TEST TEXT TEMPLATE' )
    @note_template        = Deft::NoteTemplate.new( 'TEST NOTE TEMPLATE' )
    @boolean_template     = Deft::BooleanTemplate.new( 'TEST BOOLEAN TEMPLATE' )
    @string_template      = Deft::StringTemplate.new( 'TEST STRING TEMPLATE' )
    @select_template      = Deft::SelectTemplate.new( 'TEST SELECT TEMPLATE' )
    @multiselect_template = Deft::MultiselectTemplate.new( 'TEST MULTISELECT TEMPLATE' )
    @password_template    = Deft::PasswordTemplate.new( 'TEST PASSWORD TEMPLATE' )
  end

  # to_s で string テンプレートの templates 文字列が正しく生成されることをテスト
  public
  def test_string_template
    @string_template.default = 'TEST DEFAULT'
    @string_template.short_description = 'TEST SHORT DESCRIPTION'
    @string_template.extended_description = 'TEST EXTENDED DESCRIPTION'
    @string_template.short_description_ja = 'TEST SHORT DESCRIPTION JA'
    @string_template.extended_description_ja = 'TEST EXTENDED DESCRIPTION JA'
    assert_equal( (<<-STRING_TEMPLATE).chomp, @string_template.to_s, "string テンプレートの to_s が正しい値を返さない" )
Template: TEST STRING TEMPLATE
Type: string
Default: TEST DEFAULT
Description: TEST SHORT DESCRIPTION
 TEST EXTENDED DESCRIPTION
Description-ja: TEST SHORT DESCRIPTION JA
 TEST EXTENDED DESCRIPTION JA
   STRING_TEMPLATE
  end
  
  # to_s で boolean テンプレートの templates 文字列が正しく生成されることをテスト
  public
  def test_boolean_template
    @boolean_template.default = 'true'
    @boolean_template.short_description = 'TEST SHORT DESCRIPTION'
    @boolean_template.extended_description = 'TEST EXTENDED DESCRIPTION'
    @boolean_template.short_description_ja = 'TEST SHORT DESCRIPTION JA'
    @boolean_template.extended_description_ja = 'TEST EXTENDED DESCRIPTION JA'
    assert_equal( (<<-BOOLEAN_TEMPLATE).chomp, @boolean_template.to_s, "boolean テンプレートの to_s が正しい値を返さない" )
Template: TEST BOOLEAN TEMPLATE
Type: boolean
Default: true
Description: TEST SHORT DESCRIPTION
 TEST EXTENDED DESCRIPTION
Description-ja: TEST SHORT DESCRIPTION JA
 TEST EXTENDED DESCRIPTION JA
   BOOLEAN_TEMPLATE
  end

  # to_s で select テンプレートの templates 文字列が正しく生成されることをテスト
  public
  def test_select_template
    @select_template.default = 'TEST DEFAULT'
    @select_template.choices = ['TEST DEFAULT', 'CHOICE #2', 'CHOICE #3']
    @select_template.short_description = 'TEST SHORT DESCRIPTION'
    @select_template.extended_description = 'TEST EXTENDED DESCRIPTION'
    @select_template.short_description_ja = 'TEST SHORT DESCRIPTION JA'
    @select_template.extended_description_ja = 'TEST EXTENDED DESCRIPTION JA'
    assert_equal( (<<-SELECT_TEMPLATE).chomp, @select_template.to_s, "select テンプレートの to_s が正しい値を返さない" )
Template: TEST SELECT TEMPLATE
Type: select
Choices: TEST DEFAULT, CHOICE #2, CHOICE #3
Default: TEST DEFAULT
Description: TEST SHORT DESCRIPTION
 TEST EXTENDED DESCRIPTION
Description-ja: TEST SHORT DESCRIPTION JA
 TEST EXTENDED DESCRIPTION JA
   SELECT_TEMPLATE
  end

  # to_s で multiselect テンプレートの templates 文字列が正しく生成されることをテスト
  public
  def test_multiselect_template
    @multiselect_template.default = 'TEST DEFAULT'
    @multiselect_template.choices = ['TEST DEFAULT', 'CHOICE #2', 'CHOICE #3']
    @multiselect_template.short_description = 'TEST SHORT DESCRIPTION'
    @multiselect_template.extended_description = 'TEST EXTENDED DESCRIPTION'
    @multiselect_template.short_description_ja = 'TEST SHORT DESCRIPTION JA'
    @multiselect_template.extended_description_ja = 'TEST EXTENDED DESCRIPTION JA'
    assert_equal( (<<-MULTISELECT_TEMPLATE).chomp, @multiselect_template.to_s, "multiselect テンプレートの to_s が正しい値を返さない" )
Template: TEST MULTISELECT TEMPLATE
Type: multiselect
Choices: TEST DEFAULT, CHOICE #2, CHOICE #3
Default: TEST DEFAULT
Description: TEST SHORT DESCRIPTION
 TEST EXTENDED DESCRIPTION
Description-ja: TEST SHORT DESCRIPTION JA
 TEST EXTENDED DESCRIPTION JA
   MULTISELECT_TEMPLATE
  end

  # to_s で note テンプレートの templates 文字列が正しく生成されることをテスト
  public
  def test_note_template
    @note_template.short_description = 'TEST SHORT DESCRIPTION'
    @note_template.extended_description = 'TEST EXTENDED DESCRIPTION'
    @note_template.short_description_ja = 'TEST SHORT DESCRIPTION JA'
    @note_template.extended_description_ja = 'TEST EXTENDED DESCRIPTION JA'
    assert_equal( (<<-NOTE_TEMPLATE).chomp, @note_template.to_s, "note テンプレートの to_s が正しい値を返さない" )
Template: TEST NOTE TEMPLATE
Type: note
Description: TEST SHORT DESCRIPTION
 TEST EXTENDED DESCRIPTION
Description-ja: TEST SHORT DESCRIPTION JA
 TEST EXTENDED DESCRIPTION JA
   NOTE_TEMPLATE
  end

  # to_s で text テンプレートの templates 文字列が正しく生成されることをテスト
  public
  def test_text_template
    @text_template.short_description = 'TEST SHORT DESCRIPTION'
    @text_template.extended_description = 'TEST EXTENDED DESCRIPTION'
    @text_template.short_description_ja = 'TEST SHORT DESCRIPTION JA'
    @text_template.extended_description_ja = 'TEST EXTENDED DESCRIPTION JA'
    assert_equal( (<<-TEXT_TEMPLATE).chomp, @text_template.to_s, "text テンプレートの to_s が正しい値を返さない" )
Template: TEST TEXT TEMPLATE
Type: text
Description: TEST SHORT DESCRIPTION
 TEST EXTENDED DESCRIPTION
Description-ja: TEST SHORT DESCRIPTION JA
 TEST EXTENDED DESCRIPTION JA
   TEXT_TEMPLATE
  end

  # to_s で password テンプレートの templates 文字列が正しく生成されることをテスト
  public
  def test_password_template
    @password_template.default = 'TEST DEFAULT'
    @password_template.short_description = 'TEST SHORT DESCRIPTION'
    @password_template.extended_description = 'TEST EXTENDED DESCRIPTION'
    @password_template.short_description_ja = 'TEST SHORT DESCRIPTION JA'
    @password_template.extended_description_ja = 'TEST EXTENDED DESCRIPTION JA'
    assert_equal( (<<-PASSWORD_TEMPLATE).chomp, @password_template.to_s, "password テンプレートの to_s が正しい値を返さない" )
Template: TEST PASSWORD TEMPLATE
Type: password
Default: TEST DEFAULT
Description: TEST SHORT DESCRIPTION
 TEST EXTENDED DESCRIPTION
Description-ja: TEST SHORT DESCRIPTION JA
 TEST EXTENDED DESCRIPTION JA
   PASSWORD_TEMPLATE
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
