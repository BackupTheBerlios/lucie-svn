#
# $Id: tc_boolean-template.rb 628 2005-05-31 09:55:09Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 628 $
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'deft/boolean-template'
require 'deft/multiselect-template'
require 'deft/note-template'
require 'deft/password-template'
require 'deft/select-template'
require 'deft/string-template'
require 'deft/text-template'
require 'test/unit'

class RequiredAttributeExceptionTest < Test::Unit::TestCase
  # short/extended description が揃っていない場合の 
  # Deft::Exception::RequiredAttributeException をテスト
  public
  def description_test( aTemplate )
    assert_raises( Deft::Exception::RequiredAttributeException,
                   "Deft::Exception::RequiredAttributeException が raise されなかった" ) do
      aTemplate.to_s
    end
  end
end

# select テンプレートでのテスト
class TC_SelectTemplateRequiredAttributeException < RequiredAttributeExceptionTest
  public
  def setup
    @select_template = Deft::SelectTemplate.new( 'TEST SELECT TEMPLATE' )
  end

  public
  def test_description_required_attribute_exception
    description_test( @select_template )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
