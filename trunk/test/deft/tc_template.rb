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
  
  # template �᥽�åɤǥƥ�ץ졼�Ȥ���������Ͽ����뤳�Ȥ�ƥ���
  public
  def test_templates
    template1 = template( 'TEST/TEMPLATE#1' )
    template2 = template( 'TEST/TEMPLATE#2' )
    template3 = template( 'TEST/TEMPLATE#3' )    
    assert_equal( [template1, template2, template3], Deft::Template.templates,
                  '�ƥ�ץ졼�Ȥ���������Ͽ����Ƥ��ʤ�' )
  end

  public
  def test_inspect
    template = template( 'TEST/TEMPLATE' )
    assert_equal( %{#<Deft::Template: @name="TEST/TEMPLATE">}, template.inspect,
                  "inspect ���֤��ͤ��������ʤ�" )
  end

  # template_type= ���������ʤ��ƥ�ץ졼�Ȥη�����ꤷ���Ȥ����㳰�� raise ����뤳�Ȥ�ƥ���
  public
  def test_unknown_template_type_exception
    test_template = template( 'TEST/TEMPLATE' )
    assert_raises( Deft::Exception::UnknownTemplateTypeException, 
                   "template_type= �� Deft::Exception::UnknownTemplateTypeException �� raise ����ʤ��ä�" ) do 
      test_template.template_type= 'WRONG TEMPLATE TYPE'
    end
  end

  # template_type= �ǥƥ�ץ졼�Ȥη�������Ǥ��뤳�Ȥ��ǧ
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
  
  # ��Ͽ����Ƥ���ƥ�ץ졼�Ȥ����ΤȤ��ˡ�
  # template_defined? �� nil ���֤����Ȥ��ǧ
  public
  def test_template_defined_fail
    assert_nil( Deft::Template.template_defined?( 'NOT DEFINED TEMPLATE' ),
    '��Ͽ����Ƥ��ʤ��Ϥ��Υƥ�ץ졼�Ȥ�����' )
  end
  
  # �ƥ�ץ졼�Ȥ���Ͽ����template_defined? ����Ͽ����ǧ�Ǥ��뤳�Ȥ�ƥ���
  public
  def test_template_defined_success
    template( 'TEST TEMPLATE' )
    assert( Deft::Template.template_defined?( 'TEST TEMPLATE' ),
            '�ƥ�ץ졼�Ȥ���Ͽ����Ƥ��ʤ�' )
  end
  
  # ̤�ΤΥƥ�ץ졼�Ȥ� lookup �����������ƥ�ץ졼�Ȥ��Ǥ��뤳�Ȥ��ǧ
  public
  def test_lookup_unknown_template
    template = Deft::Template::lookup( 'UNKNOWN TEMPLATE' )
    assert_kind_of( Deft::Template, template, '�ƥ�ץ졼�Ȥ� �����㤦' )
    assert_equal( 'UNKNOWN TEMPLATE', template.name, '�ƥ�ץ졼�Ȥ�̾�����㤦' )
  end
  
  # ���ΤΥƥ�ץ졼�Ȥ� lookup �Ǥ��뤳�Ȥ��ǧ
  public
  def test_lookup_known_template
    known_template = template( 'KNOWN TEMPLATE' )
    assert_equal( known_template, Deft::Template::lookup( 'KNOWN TEMPLATE' ),
                  '�ƥ�ץ졼�Ȥ���Ͽ����Ƥ��ʤ�' )
    assert_equal( 'KNOWN TEMPLATE', known_template.name, '�ƥ�ץ졼�Ȥ�̾�����㤦' )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
