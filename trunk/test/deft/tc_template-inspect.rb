#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'deft/template'
require 'test/unit'

# �ƥƥ�ץ졼�ȥ��饹�� inspect �᥽�åɤ�ƥ���
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
    template = template( 'TEXT TEMPLATE' ) do |template|
      template.template_type = 'text'
    end
    assert_equal( '#<Deft::TextTemplate: @name="TEXT TEMPLATE">',
                  template.inspect, 'text �ƥ�ץ졼�Ȥ� inspect ʸ�����������ʤ�' )
  end
  
  public
  def test_inspect_select_template
    template = template( 'SELECT TEMPLATE' ) do |template|
      template.template_type = 'select'
    end
    assert_equal( '#<Deft::SelectTemplate: @name="SELECT TEMPLATE">',
                  template.inspect, 'select �ƥ�ץ졼�Ȥ� inspect ʸ�����������ʤ�' )
  end
  
  public
  def test_inspect_note_template
    template = template( 'NOTE TEMPLATE' ) do |template|
      template.template_type = 'note'
    end
    assert_equal( '#<Deft::NoteTemplate: @name="NOTE TEMPLATE">',
                  template.inspect, 'note �ƥ�ץ졼�Ȥ� inspect ʸ�����������ʤ�' )
  end
  
  public
  def test_inspect_boolean_template
    template = template( 'BOOLEAN TEMPLATE' ) do |template|
      template.template_type = 'boolean'
    end
    assert_equal( '#<Deft::BooleanTemplate: @name="BOOLEAN TEMPLATE">',
                  template.inspect, 'boolean �ƥ�ץ졼�Ȥ� inspect ʸ�����������ʤ�' )
  end

  public
  def test_inspect_string_template
    template = template( 'STRING TEMPLATE' ) do |template|
      template.template_type = 'string'
    end
    assert_equal( '#<Deft::StringTemplate: @name="STRING TEMPLATE">',
                  template.inspect, 'string �ƥ�ץ졼�Ȥ� inspect ʸ�����������ʤ�' )
  end  
  
  public
  def test_inspect_multiselect_template
    template = template( 'MULTISELECT TEMPLATE' ) do |template|
      template.template_type = 'multiselect'
    end
    assert_equal( '#<Deft::MultiselectTemplate: @name="MULTISELECT TEMPLATE">',
                  template.inspect, 'multiselect �ƥ�ץ졼�Ȥ� inspect ʸ�����������ʤ�' )
  end
  
  public
  def test_inspect_password_template
    template = template( 'PASSWORD TEMPLATE' ) do |template|
      template.template_type = 'password'
    end
    assert_equal( '#<Deft::PasswordTemplate: @name="PASSWORD TEMPLATE">',
                  template.inspect, 'password �ƥ�ץ졼�Ȥ� inspect ʸ�����������ʤ�' )
  end        
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
