#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'deft/template'
require 'test/unit'

class TC_TemplateInvalidAttributeException < Test::Unit::TestCase
  public
  def teardown
    Deft::Template.clear
  end
  
  public
  def test_exception_raised_text_template
    assert_raises( Deft::Exception::InvalidAttributeException,
                   'InvalidAttributeException ‚ª raise ‚³‚ê‚È‚©‚Á‚½' ) do
      template( 'TEST TEMPLATE' ) do |template|
        template.template_type = 'text'
        template.default = 'DEFAULT'
      end
    end    
    Deft::Template.clear
    assert_raises( Deft::Exception::InvalidAttributeException,
              'InvalidAttributeException ‚ª raise ‚³‚ê‚È‚©‚Á‚½' ) do
      template( 'TEST TEMPLATE' ) do |template|
        template.template_type = 'text'
        template.choices = 'CHOICES'
      end
    end    
  end
  
  public
  def test_exception_raised_note_template
    assert_raises( Deft::Exception::InvalidAttributeException,
                   'InvalidAttributeException ‚ª raise ‚³‚ê‚È‚©‚Á‚½' ) do
      template( 'TEST TEMPLATE' ) do |template|
        template.template_type = 'note'
        template.default = 'DEFAULT'
      end
    end
    Deft::Template.clear
    assert_raises( Deft::Exception::InvalidAttributeException,
              'InvalidAttributeException ‚ª raise ‚³‚ê‚È‚©‚Á‚½' ) do
      template( 'TEST TEMPLATE' ) do |template|
        template.template_type = 'note'
        template.choices = 'CHOICES'
      end
    end      
  end
  
  public
  def test_exception_raised_boolean_template
    assert_raises( Deft::Exception::InvalidAttributeException,
              'InvalidAttributeException ‚ª raise ‚³‚ê‚È‚©‚Á‚½' ) do
      template( 'TEST TEMPLATE' ) do |template|
        template.template_type = 'boolean'
        template.choices = 'CHOICES'
      end
    end 
  end
  
  public
  def test_exception_raised_string_template
    assert_raises( Deft::Exception::InvalidAttributeException,
              'InvalidAttributeException ‚ª raise ‚³‚ê‚È‚©‚Á‚½' ) do
      template( 'TEST TEMPLATE' ) do |template|
        template.template_type = 'string'
        template.choices = 'CHOICES'
      end
    end
  end
  
  public
  def test_exception_raised_password_template
    assert_raises( Deft::Exception::InvalidAttributeException,
              'InvalidAttributeException ‚ª raise ‚³‚ê‚È‚©‚Á‚½' ) do
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