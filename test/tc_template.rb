#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'lucie/boolean-template'
require 'lucie/template'
require 'test/unit'

class TC_Template < Test::Unit::TestCase
  public
  def test_templates
    Lucie::Template.clear
    template 'TEST/TEMPLATE#1', Lucie::BooleanTemplate
    template 'TEST/TEMPLATE#2', Lucie::BooleanTemplate
    template 'TEST/TEMPLATE#3', Lucie::BooleanTemplate
    
    assert_equal 3, Lucie::Template.templates.size, '登録されているテンプレートの数が違う'
    assert_equal 'TEST/TEMPLATE#1', Lucie::Template.templates[0].name, 'テンプレートの名前が違う'
    assert_kind_of Lucie::BooleanTemplate, Lucie::Template.templates[0], 'テンプレートの型が違う'
    assert_equal 'TEST/TEMPLATE#2', Lucie::Template.templates[1].name, 'テンプレートの名前が違う'
    assert_kind_of Lucie::BooleanTemplate, Lucie::Template.templates[1], 'テンプレートの型が違う'
    assert_equal 'TEST/TEMPLATE#3', Lucie::Template.templates[2].name, 'テンプレートの名前が違う'
    assert_kind_of Lucie::BooleanTemplate, Lucie::Template.templates[2], 'テンプレートの型が違う'
  end

  # 登録されているテンプレートが空のときに、
  # template_defined? が nil を返すことを確認
  public
  def test_template_defined_fail
    Lucie::Template.clear
    assert_nil Lucie::Template.template_defined?( 'NOT DEFINED TEMPLATE' ), '登録されていないはずのテンプレートがある'
  end
  
  # テンプレートを登録し、template_defined? で登録が確認できることをテスト
  public
  def test_template_defined_success
    Lucie::Template.clear
    template( 'TEST TEMPLATE', Lucie::BooleanTemplate )
    assert Lucie::Template.template_defined?( 'TEST TEMPLATE' ), 'テンプレートが登録されていない'
  end
  
  public
  def test_template
    assert_kind_of Lucie::BooleanTemplate, template( 'LUCIE/OVERVIEW', Lucie::BooleanTemplate ), 'テンプレートの Type が違う'
  end
  
  # clear のテスト
  public
  def test_clear
    Lucie::Template::TEMPLATES['TEST TEMPLATE'] = Lucie::Template.new( 'TEST TEMPLATE' )
    Lucie::Template.clear
    assert_equal 0, Lucie::Template::TEMPLATES.size, 'TEMPLATES がクリアされていない'
  end

  # lookup のテスト (未知のテンプレート)
  public
  def test_lookup_unknown_template
    Lucie::Template.clear
    template = Lucie::Template::lookup( 'UNKNOWN TEMPLATE', Lucie::BooleanTemplate )
    assert_kind_of Lucie::BooleanTemplate, template, 'テンプレートの Type が違う'
    assert_equal 'UNKNOWN TEMPLATE', template.name, 'テンプレートが登録されていない'
  end
  
  # lookup のテスト (既知のテンプレート)
  public
  def test_lookup_known_template
    Lucie::Template.clear
    template = template( 'KNOWN TEMPLATE', Lucie::BooleanTemplate )
    assert_equal template, Lucie::Template::lookup( 'KNOWN TEMPLATE', Lucie::BooleanTemplate ), 'テンプレートが登録されていない'
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: