#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$KCODE = 'SJIS'
$LOAD_PATH.unshift './lib'

require 'deft/multiselect-template'
require 'test/unit'

class TC_MultiselectTemplate < Test::Unit::TestCase
  public
  def setup
    Deft::Template.clear
  end
  
  public
  def teardown
    Deft::Template.clear
  end
  
  public
  def test_to_s
    template = template( 'TEST/MULTISELECT-TEMPLATE' ) do |template|
      template.template_type = 'multiselect'
      template.choices = 'CHOICE #1, CHOICE #1, CHOICE #3'
      template.default = 'CHOICE #1'
      template.short_description = 'This is a short description'
      template.extended_description = 'This is a extended description'
      template.short_description_ja = '����͒Z���f�X�N���v�V�����ł�'
      template.extended_description_ja = '����͒����f�X�N���v�V�����ł�'
    end
    assert_equal( 'TEST/MULTISELECT-TEMPLATE', template.name,
                  'name �A�g���r���[�g�̒l���������Ȃ�' )
    assert_equal( 'multiselect', template.template_type,
                  'template_type �A�g���r���[�g�̒l���������Ȃ�' )
    assert_equal( 'CHOICE #1, CHOICE #1, CHOICE #3', template.choices,
                  'choices �A�g���r���[�g�̒l���������Ȃ�' )
    assert_equal( 'CHOICE #1', template.default,
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
