#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'deft/template'
require 'test/unit'

# 各テンプレートクラスの inspect メソッドをテスト
class TC_TemplateInspect < Test::Unit::TestCase
  public
  def setup
    Deft::Template.clear
  end
  
  public
  def teardown
    Deft::Template.clear
  end
  
  public
  def test_inspect_text_template
    template = template( 'TEST TEMPLATE' ) do |template|
      template.template_type = 'text'
    end
    assert_equal( '#<Deft::TextTemplate: @name="TEST TEMPLATE">',
                  template.inspect )
  end
  
  public
  def test_inspect_select_template
    template = template( 'TEST TEMPLATE' ) do |template|
      template.template_type = 'select'
    end
    assert_equal( '#<Deft::SelectTemplate: @name="TEST TEMPLATE">',
                  template.inspect )
  end
  
  public
  def test_inspect_note_template
    template = template( 'TEST TEMPLATE' ) do |template|
      template.template_type = 'note'
    end
    assert_equal( '#<Deft::NoteTemplate: @name="TEST TEMPLATE">',
                  template.inspect )
  end
  
  public
  def test_inspect_boolean_template
    template = template( 'TEST TEMPLATE' ) do |template|
      template.template_type = 'boolean'
    end
    assert_equal( '#<Deft::BooleanTemplate: @name="TEST TEMPLATE">',
                  template.inspect )
  end

  public
  def test_inspect_string_template
    template = template( 'TEST TEMPLATE' ) do |template|
      template.template_type = 'string'
    end
    assert_equal( '#<Deft::StringTemplate: @name="TEST TEMPLATE">',
                  template.inspect )
  end  
  
  public
  def test_inspect_multiselect_template
    template = template( 'TEST TEMPLATE' ) do |template|
      template.template_type = 'multiselect'
    end
    assert_equal( '#<Deft::MultiselectTemplate: @name="TEST TEMPLATE">',
                  template.inspect )
  end
  
  public
  def test_inspect_password_template
    template = template( 'TEST TEMPLATE' ) do |template|
      template.template_type = 'password'
    end
    assert_equal( '#<Deft::PasswordTemplate: @name="TEST TEMPLATE">',
                  template.inspect )
  end        
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: