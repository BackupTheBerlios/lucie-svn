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
    Deft::Template.clear
  end
  
  public
  def teardown
    Deft::Template.clear
  end
  
  public
  def test_register
    template = template( 'TEST/BOOLEAN-TEMPLATE' ) do |template|
      template.template_type = 'boolean'
      template.default = 'true'
      template.short_description = 'This is a short description'
      template.extended_description = 'This is a extended description'
      template.short_description_ja = '����͒Z���f�X�N���v�V�����ł�'
      template.extended_description_ja = '����͒����f�X�N���v�V�����ł�'      
    end
    assert_equal( 'TEST/BOOLEAN-TEMPLATE', template.name,
                  'name �A�g���r���[�g�̒l���������Ȃ�' )
    assert_equal( 'boolean', template.template_type,
                  'template_type �A�g���r���[�g�̒l���������Ȃ�' )
    assert_equal( 'true', template.default,
                  'default �A�g���r���[�g�̒l���������Ȃ�' )
    assert_equal( 'This is a short description', template.short_description,
                  'short_description �A�g���r���[�g�̒l���������Ȃ�' )
    assert_equal( 'This is a extended description', template.extended_description,
                  'extended_description �A�g���r���[�g�̒l���������Ȃ�' ) 
    assert_equal( '����͒Z���f�X�N���v�V�����ł�', template.short_description_ja,
                  'short_description_ja �A�g���r���[�g�̒l���������Ȃ�' ) 
    assert_equal( '����͒����f�X�N���v�V�����ł�', template.extended_description_ja,
                  'extended_description_ja �A�g���r���[�g�̒l���������Ȃ�' )    
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
