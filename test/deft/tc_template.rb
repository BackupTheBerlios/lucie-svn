#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'deft/boolean-template'
require 'deft/template'
require 'test/unit'

class TC_Template < Test::Unit::TestCase
  public
  def setup
    Deft::Template.clear
  end
  
  public
  def setup
    Deft::Template.clear
  end
  
  public
  def test_templates
    template1 = template( 'TEST/TEMPLATE#1' )
    template2 = template( 'TEST/TEMPLATE#2' )
    template3 = template( 'TEST/TEMPLATE#3' )    
    assert_equal( [template1, template2, template3], Deft::Template.templates,
                  '�e���v���[�g���������o�^����Ă��Ȃ�' )
  end
  
  # �o�^����Ă���e���v���[�g����̂Ƃ��ɁA
  # template_defined? �� nil ��Ԃ����Ƃ��m�F
  public
  def test_template_defined_fail
    assert_nil( Deft::Template.template_defined?( 'NOT DEFINED TEMPLATE' ),
                '�o�^����Ă��Ȃ��͂��̃e���v���[�g������' )
  end
  
  # �e���v���[�g��o�^���Atemplate_defined? �œo�^���m�F�ł��邱�Ƃ��e�X�g
  public
  def test_template_defined_success
    template( 'TEST TEMPLATE' )
    assert( Deft::Template.template_defined?( 'TEST TEMPLATE' ),
            '�e���v���[�g���o�^����Ă��Ȃ�' )
  end
  
  # ���m�̃e���v���[�g�� lookup ���A�V�����e���v���[�g���ł��邱�Ƃ��m�F
  public
  def test_lookup_unknown_template
    template = Deft::Template::lookup( 'UNKNOWN TEMPLATE' )
    assert_kind_of( Deft::Template, template, '�e���v���[�g�� �^���Ⴄ' )
    assert_equal( 'UNKNOWN TEMPLATE', template.name, '�e���v���[�g�̖��O���Ⴄ' )
  end
  
  # ���m�̃e���v���[�g�� lookup �ł��邱�Ƃ��m�F
  public
  def test_lookup_known_template
    known_template = template( 'KNOWN TEMPLATE' )
    assert_equal( known_template, Deft::Template::lookup( 'KNOWN TEMPLATE' ),
                  '�e���v���[�g���o�^����Ă��Ȃ�' )
    assert_equal( 'KNOWN TEMPLATE', known_template.name, '�e���v���[�g�̖��O���Ⴄ' )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: