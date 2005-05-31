#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'deft/boolean-template'
require 'deft/template'
require 'test/unit'

class TC_Template < Test::Unit::TestCase
  public
  def setup
    Deft::Template.clear
  end
  
  public
  def setup
    Deft::Template.clear
  end
  
  # template メソッドでテンプレートが正しく登録されることをテスト
  public
  def test_templates
    template1 = template( 'TEST/TEMPLATE#1' )
    template2 = template( 'TEST/TEMPLATE#2' )
    template3 = template( 'TEST/TEMPLATE#3' )    
    assert_equal( [template1, template2, template3], Deft::Template.templates,
                  'テンプレートが正しく登録されていない' )
  end

  public
  def test_inspect
    template = template( 'TEST/TEMPLATE' )
    assert_equal( %{#<Deft::Template: @name="TEST/TEMPLATE">}, template.inspect,
                  "inspect の返す値が正しくない" )
  end

  # template_type= で正しくないテンプレートの型を指定したときに例外が raise されることをテスト
  public
  def test_unknown_template_type_exception
    test_template = template( 'TEST/TEMPLATE' )
    assert_raises( Deft::Exception::UnknownTemplateTypeException, 
                   "template_type= で Deft::Exception::UnknownTemplateTypeException が raise されなかった" ) do 
      test_template.template_type= 'WRONG TEMPLATE TYPE'
    end
  end

  # template_type= でテンプレートの型を設定できることを確認
  public
  def test_template_type
    test_template = template( 'TEST/TEMPLATE' )

    test_template.template_type = 'string'
    assert_kind_of Deft::StringTemplate, Deft::Template['TEST/TEMPLATE']

    test_template.template_type = 'boolean'
    assert_kind_of Deft::BooleanTemplate, Deft::Template['TEST/TEMPLATE']

    test_template.template_type = 'select'
    assert_kind_of Deft::SelectTemplate, Deft::Template['TEST/TEMPLATE']

    test_template.template_type = 'multiselect'
    assert_kind_of Deft::MultiselectTemplate, Deft::Template['TEST/TEMPLATE']

    test_template.template_type = 'note'
    assert_kind_of Deft::NoteTemplate, Deft::Template['TEST/TEMPLATE']

    test_template.template_type = 'text'
    assert_kind_of Deft::TextTemplate, Deft::Template['TEST/TEMPLATE']

    test_template.template_type = 'password'
    assert_kind_of Deft::PasswordTemplate, Deft::Template['TEST/TEMPLATE']
  end
  
  # 登録されているテンプレートが空のときに、
  # template_defined? が nil を返すことを確認
  public
  def test_template_defined_fail
    assert_nil( Deft::Template.template_defined?( 'NOT DEFINED TEMPLATE' ),
    '登録されていないはずのテンプレートがある' )
  end
  
  # テンプレートを登録し、template_defined? で登録が確認できることをテスト
  public
  def test_template_defined_success
    template( 'TEST TEMPLATE' )
    assert( Deft::Template.template_defined?( 'TEST TEMPLATE' ),
            'テンプレートが登録されていない' )
  end
  
  # 未知のテンプレートを lookup し、新しいテンプレートができることを確認
  public
  def test_lookup_unknown_template
    template = Deft::Template::lookup( 'UNKNOWN TEMPLATE' )
    assert_kind_of( Deft::Template, template, 'テンプレートの 型が違う' )
    assert_equal( 'UNKNOWN TEMPLATE', template.name, 'テンプレートの名前が違う' )
  end
  
  # 既知のテンプレートを lookup できることを確認
  public
  def test_lookup_known_template
    known_template = template( 'KNOWN TEMPLATE' )
    assert_equal( known_template, Deft::Template::lookup( 'KNOWN TEMPLATE' ),
                  'テンプレートが登録されていない' )
    assert_equal( 'KNOWN TEMPLATE', known_template.name, 'テンプレートの名前が違う' )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
