#
# $Id: tc_template_getter_methods.rb 520 2005-04-05 05:15:36Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 520 $
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'deft/template'
require 'test/unit'

class TC_TemplateGetterMethods < Test::Unit::TestCase
  public
  def teardown
    Deft::Template.clear
  end
  
  public
  def test_attributes
    template = template( 'TEST TEMPLATE' ) do |template|
      template.template_type = 'select'
      template.default = 'debian'
      template.choices = ['debian', 'redhat', 'mandrake']
      template.short_description = 'Which distro do you use?'
      template.extended_description = 
        'Which distro do you use for you home computer?'
    end
    assert_equal( 'select', template.template_type, 'テンプレートの型が違う' )
    assert_equal( 'debian', template.default, 'Deafult: が違う' )
    assert_equal( ['debian', 'redhat', 'mandrake'],
                  template.choices, 'Choices: が違う' )
    assert_equal( 'Which distro do you use?',
                  template.short_description, 'Short description が違う' )
    assert_equal( 'Which distro do you use for you home computer?',
                  template.extended_description,
                  'Extended description が違う' )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
