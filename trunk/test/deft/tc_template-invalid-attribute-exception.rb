# =各テンプレートについて Deft::Exception::InvalidAttributeException が raise されることをテスト
#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'deft/template'
require 'test/unit'

# string テンプレートでのテスト
class TC_StringTemplateInvalidAttributeException < Test::Unit::TestCase
  public
  def teardown
    Deft::Template.clear
  end

  # string テンプレートでは Choices: 属性は無効
  public
  def test_exception_raised
    assert_raises( Deft::Exception::InvalidAttributeException,
                   'InvalidAttributeException が raise されなかった' ) do
      template( 'TEST TEMPLATE' ) do |template|
        template.template_type = 'string'
        template.choices = 'CHOICES'
      end
    end
  end
end

# boolean テンプレートでのテスト
class TC_BooleanTemplateInvalidAttributeException < Test::Unit::TestCase
  public
  def teardown
    Deft::Template.clear
  end

  # boolean テンプレートでは Choices: 属性は無効
  public
  def test_exception_raised
    assert_raises( Deft::Exception::InvalidAttributeException,
                   'InvalidAttributeException が raise されなかった' ) do
      template( 'TEST TEMPLATE' ) do |template|
        template.template_type = 'boolean'
        template.choices = 'CHOICES'
      end
    end 
  end
end

# note テンプレートでのテスト
class TC_NoteTemplateInvalidAttributeException < Test::Unit::TestCase
  public
  def teardown
    Deft::Template.clear
  end

  # note テンプレートでは Default: 属性は無効
  public
  def test_exception_raised_with_default_attribute
    assert_raises( Deft::Exception::InvalidAttributeException,
                   'InvalidAttributeException が raise されなかった' ) do
      template( 'TEST TEMPLATE' ) do |template|
        template.template_type = 'note'
        template.default = 'DEFAULT'
      end
    end
  end
  
  # note テンプレートでは Choices: 属性は無効
  public
  def test_exception_raised_with_choices_attribute
    assert_raises( Deft::Exception::InvalidAttributeException,
                   'InvalidAttributeException が raise されなかった' ) do
      template( 'TEST TEMPLATE' ) do |template|
        template.template_type = 'note'
        template.choices = 'CHOICES'
      end
    end      
  end
end

# text テンプレートでのテスト
class TC_TextTemplateInvalidAttributeException < Test::Unit::TestCase
  public
  def teardown
    Deft::Template.clear
  end

  # text テンプレートでは Default: 属性は無効
  public
  def test_exception_raised_with_default_attribute
    assert_raises( Deft::Exception::InvalidAttributeException,
                   'InvalidAttributeException が raise されなかった' ) do
      template( 'TEST TEMPLATE' ) do |template|
        template.template_type = 'text'
        template.default = 'DEFAULT'
      end
    end    
  end

  # text テンプレートでは Choices: 属性は無効
  public
  def test_exception_raised_with_choices_attribute
    assert_raises( Deft::Exception::InvalidAttributeException,
                   'InvalidAttributeException が raise されなかった' ) do
      template( 'TEST TEMPLATE' ) do |template|
        template.template_type = 'text'
        template.choices = 'CHOICES'
      end
    end    
  end
end

# password テンプレートでのテスト
class TC_PasswordTemplateInvalidAttributeException < Test::Unit::TestCase
  public
  def teardown
    Deft::Template.clear
  end
  
  # password テンプレートでは Choices: 属性は無効
  public
  def test_exception_raised_password_template
    assert_raises( Deft::Exception::InvalidAttributeException,
                   'InvalidAttributeException が raise されなかった' ) do
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
