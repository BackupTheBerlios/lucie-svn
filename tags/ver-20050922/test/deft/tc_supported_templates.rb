#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'deft/template'
require 'test/unit'

# Debconf �Υƥ�ץ졼��
#
# * string 
# * boolean
# * select
# * multiselect
# * note
# * text
# * password
#
# �����٤ƥ��ݡ��Ȥ���Ƥ��뤳�Ȥ�ƥ���
class TC_TemplateUnknownTemplateTypeException < Test::Unit::TestCase
  public
  def setup
    Deft::Template.clear
  end

  public
  def teardown
    Deft::Template.clear
  end
  
  # Deft::Exception::UnknownTemplateTypeException �� raise ����뤳�Ȥ�ƥ���
  public
  def test_exception_raised
    assert_raises( Deft::Exception::UnknownTemplateTypeException,
                   'template_type= �᥽�åɤ� UnknownTemplateTypeException �� raise ����ʤ��ä�' ) do
      template( 'TEST TEMPLATE' ) do |template|
        template.template_type = 'UNKNOWN'
      end
    end
  end

  # Debconf �� 7 ����Υƥ�ץ졼�Ȥ����٤ƥ��ݡ��Ȥ���Ƥ��뤳�Ȥ�ƥ���
  public
  def test_exception_not_raised
    begin
      template( 'TEST TEXT TEMPLATE' ) do |template|
        template.template_type = 'text'
      end    
      template( 'TEST SELECT TEMPLATE' ) do |template|
        template.template_type = 'select'
      end    
      template( 'TEST NOTE TEMPLATE' ) do |template|
        template.template_type = 'note'
      end    
      template( 'TEST BOOLEAN TEMPLATE' ) do |template|
        template.template_type = 'boolean'
      end    
      template( 'TEST STRING TEMPLATE' ) do |template|
        template.template_type = 'string'
      end    
      template( 'TEST MULTISELECT TEMPLATE' ) do |template|
        template.template_type = 'multiselect'
      end    
      template( 'TEST PASSWORD TEMPLATE' ) do |template|
        template.template_type = 'password'
      end
    rescue 
      fail 'Debconf �Υƥ�ץ졼�Ȥ����٤ƥ��ݡ��Ȥ���Ƥ��ʤ�'
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
