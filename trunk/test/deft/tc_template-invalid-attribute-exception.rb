# =�ƥƥ�ץ졼�ȤˤĤ��� Deft::Exception::InvalidAttributeException �� raise ����뤳�Ȥ�ƥ���
#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'deft/template'
require 'test/unit'

# string �ƥ�ץ졼�ȤǤΥƥ���
class TC_StringTemplateInvalidAttributeException < Test::Unit::TestCase
  public
  def teardown
    Deft::Template.clear
  end

  # string �ƥ�ץ졼�ȤǤ� Choices: °����̵��
  public
  def test_exception_raised
    assert_raises( Deft::Exception::InvalidAttributeException,
                   'InvalidAttributeException �� raise ����ʤ��ä�' ) do
      template( 'TEST TEMPLATE' ) do |template|
        template.template_type = 'string'
        template.choices = 'CHOICES'
      end
    end
  end
end

# boolean �ƥ�ץ졼�ȤǤΥƥ���
class TC_BooleanTemplateInvalidAttributeException < Test::Unit::TestCase
  public
  def teardown
    Deft::Template.clear
  end

  # boolean �ƥ�ץ졼�ȤǤ� Choices: °����̵��
  public
  def test_exception_raised
    assert_raises( Deft::Exception::InvalidAttributeException,
                   'InvalidAttributeException �� raise ����ʤ��ä�' ) do
      template( 'TEST TEMPLATE' ) do |template|
        template.template_type = 'boolean'
        template.choices = 'CHOICES'
      end
    end 
  end
end

# note �ƥ�ץ졼�ȤǤΥƥ���
class TC_NoteTemplateInvalidAttributeException < Test::Unit::TestCase
  public
  def teardown
    Deft::Template.clear
  end

  # note �ƥ�ץ졼�ȤǤ� Default: °����̵��
  public
  def test_exception_raised_with_default_attribute
    assert_raises( Deft::Exception::InvalidAttributeException,
                   'InvalidAttributeException �� raise ����ʤ��ä�' ) do
      template( 'TEST TEMPLATE' ) do |template|
        template.template_type = 'note'
        template.default = 'DEFAULT'
      end
    end
  end
  
  # note �ƥ�ץ졼�ȤǤ� Choices: °����̵��
  public
  def test_exception_raised_with_choices_attribute
    assert_raises( Deft::Exception::InvalidAttributeException,
                   'InvalidAttributeException �� raise ����ʤ��ä�' ) do
      template( 'TEST TEMPLATE' ) do |template|
        template.template_type = 'note'
        template.choices = 'CHOICES'
      end
    end      
  end
end

# text �ƥ�ץ졼�ȤǤΥƥ���
class TC_TextTemplateInvalidAttributeException < Test::Unit::TestCase
  public
  def teardown
    Deft::Template.clear
  end

  # text �ƥ�ץ졼�ȤǤ� Default: °����̵��
  public
  def test_exception_raised_with_default_attribute
    assert_raises( Deft::Exception::InvalidAttributeException,
                   'InvalidAttributeException �� raise ����ʤ��ä�' ) do
      template( 'TEST TEMPLATE' ) do |template|
        template.template_type = 'text'
        template.default = 'DEFAULT'
      end
    end    
  end

  # text �ƥ�ץ졼�ȤǤ� Choices: °����̵��
  public
  def test_exception_raised_with_choices_attribute
    assert_raises( Deft::Exception::InvalidAttributeException,
                   'InvalidAttributeException �� raise ����ʤ��ä�' ) do
      template( 'TEST TEMPLATE' ) do |template|
        template.template_type = 'text'
        template.choices = 'CHOICES'
      end
    end    
  end
end

# password �ƥ�ץ졼�ȤǤΥƥ���
class TC_PasswordTemplateInvalidAttributeException < Test::Unit::TestCase
  public
  def teardown
    Deft::Template.clear
  end
  
  # password �ƥ�ץ졼�ȤǤ� Choices: °����̵��
  public
  def test_exception_raised_password_template
    assert_raises( Deft::Exception::InvalidAttributeException,
                   'InvalidAttributeException �� raise ����ʤ��ä�' ) do
      template( 'TEST TEMPLATE' ) do |template|
        template.template_type = 'password'
        template.choices = 'CHOICES'
      end
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
