#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'deft/template'
require 'test/unit'

class TC_TemplateUnknownTemplateTypeException < Test::Unit::TestCase
  public
  def teardown
    Deft::Template.clear
  end
  
  public
  def test_exception_raised
    assert_raises( Deft::Exception::UnknownTemplateTypeException,
                   'UnknownTemplateTypeException が raise されなかった' ) do
      template( 'TEST TEMPLATE' ) do |template|
        template.template_type = 'UNKNOWN'
      end
    end
  end
  
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
      fail 'テンプレートがすべてサポートされていない'
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
