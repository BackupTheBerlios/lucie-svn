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
  
  # @choices= �� Deft::Exception::InvalidAttributeException ���֤����Ȥ�ƥ���
  public 
  def test_setter_choices_raises_invalid_attribute_exception
    assert_raises( Deft::Exception::InvalidAttributeException, 
                   '@choices �ؤ������� InvalidAttributeException �� raise ����ʤ��ä�' ) do 
      @boolean_template.choices = 'THIS MUST RAISE EXCEPTION'
    end
  end

  # inspect ���֤��ͤ�ƥ���
  public
  def test_inspect
    assert_equal( %{#<Deft::BooleanTemplate: @name="TEST BOOLEAN TEMPLATE">},
                  @boolean_template.inspect, "inspect ���������ͤ��֤��ʤ�" )
  end
  
  public
  def test_register
    template = template( 'TEST/BOOLEAN-TEMPLATE' ) do |template|
      template.template_type = 'boolean'
      template.default = 'true'
      template.short_description = 'This is a short description'
      template.extended_description = 'This is a extended description'
      template.short_description_ja = '�����û���ǥ�����ץ����Ǥ�'
      template.extended_description_ja = '�����Ĺ���ǥ�����ץ����Ǥ�'      
    end
    assert_equal( 'TEST/BOOLEAN-TEMPLATE', template.name,
                  'name ���ȥ�ӥ塼�Ȥ��ͤ��������ʤ�' )
    assert_equal( 'boolean', template.template_type,
                  'template_type ���ȥ�ӥ塼�Ȥ��ͤ��������ʤ�' )
    assert_equal( 'true', template.default,
                  'default ���ȥ�ӥ塼�Ȥ��ͤ��������ʤ�' )
    assert_equal( 'This is a short description', template.short_description,
                  'short_description ���ȥ�ӥ塼�Ȥ��ͤ��������ʤ�' )
    assert_equal( 'This is a extended description', template.extended_description,
                  'extended_description ���ȥ�ӥ塼�Ȥ��ͤ��������ʤ�' ) 
    assert_equal( '�����û���ǥ�����ץ����Ǥ�', template.short_description_ja,
                  'short_description_ja ���ȥ�ӥ塼�Ȥ��ͤ��������ʤ�' ) 
    assert_equal( '�����Ĺ���ǥ�����ץ����Ǥ�', template.extended_description_ja,
                  'extended_description_ja ���ȥ�ӥ塼�Ȥ��ͤ��������ʤ�' )    
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
