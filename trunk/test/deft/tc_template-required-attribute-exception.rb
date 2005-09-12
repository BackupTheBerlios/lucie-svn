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

# short/extended description が揃っていない場合の 
# Deft::Exception::RequiredAttributeException をテスト
class TC_TemplateRequiredAttributeException < RequiredAttributeExceptionTest
  public
  def test_description_required_attribute_exception
    @select_template = Deft::SelectTemplate.new( 'TEST SELECT TEMPLATE' )
    assert_raises( Deft::Exception::RequiredAttributeException,
                   "Deft::Exception::RequiredAttributeException が raise されなかった" ) do
      @select_template.to_s
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
