#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'lucie/boolean-template'
require 'lucie/template'
require 'test/unit'

class TC_Template < Test::Unit::TestCase
  public
  def test_templates
    Lucie::Template.clear
    template 'TEST/TEMPLATE#1', Lucie::BooleanTemplate
    template 'TEST/TEMPLATE#2', Lucie::BooleanTemplate
    template 'TEST/TEMPLATE#3', Lucie::BooleanTemplate
    
    assert_equal 3, Lucie::Template.templates.size, '�o�^����Ă���e���v���[�g�̐����Ⴄ'
    assert_equal 'TEST/TEMPLATE#1', Lucie::Template.templates[0].name, '�e���v���[�g�̖��O���Ⴄ'
    assert_kind_of Lucie::BooleanTemplate, Lucie::Template.templates[0], '�e���v���[�g�̌^���Ⴄ'
    assert_equal 'TEST/TEMPLATE#2', Lucie::Template.templates[1].name, '�e���v���[�g�̖��O���Ⴄ'
    assert_kind_of Lucie::BooleanTemplate, Lucie::Template.templates[1], '�e���v���[�g�̌^���Ⴄ'
    assert_equal 'TEST/TEMPLATE#3', Lucie::Template.templates[2].name, '�e���v���[�g�̖��O���Ⴄ'
    assert_kind_of Lucie::BooleanTemplate, Lucie::Template.templates[2], '�e���v���[�g�̌^���Ⴄ'
  end

  # �o�^����Ă���e���v���[�g����̂Ƃ��ɁA
  # template_defined? �� nil ��Ԃ����Ƃ��m�F
  public
  def test_template_defined_fail
    Lucie::Template.clear
    assert_nil Lucie::Template.template_defined?( 'NOT DEFINED TEMPLATE' ), '�o�^����Ă��Ȃ��͂��̃e���v���[�g������'
  end
  
  # �e���v���[�g��o�^���Atemplate_defined? �œo�^���m�F�ł��邱�Ƃ��e�X�g
  public
  def test_template_defined_success
    Lucie::Template.clear
    template( 'TEST TEMPLATE', Lucie::BooleanTemplate )
    assert Lucie::Template.template_defined?( 'TEST TEMPLATE' ), '�e���v���[�g���o�^����Ă��Ȃ�'
  end
  
  public
  def test_template
    assert_kind_of Lucie::BooleanTemplate, template( 'LUCIE/OVERVIEW', Lucie::BooleanTemplate ), '�e���v���[�g�� Type ���Ⴄ'
  end
  
  # clear �̃e�X�g
  public
  def test_clear
    Lucie::Template::TEMPLATES['TEST TEMPLATE'] = Lucie::Template.new( 'TEST TEMPLATE' )
    Lucie::Template.clear
    assert_equal 0, Lucie::Template::TEMPLATES.size, 'TEMPLATES ���N���A����Ă��Ȃ�'
  end

  # lookup �̃e�X�g (���m�̃e���v���[�g)
  public
  def test_lookup_unknown_template
    Lucie::Template.clear
    template = Lucie::Template::lookup( 'UNKNOWN TEMPLATE', Lucie::BooleanTemplate )
    assert_kind_of Lucie::BooleanTemplate, template, '�e���v���[�g�� Type ���Ⴄ'
    assert_equal 'UNKNOWN TEMPLATE', template.name, '�e���v���[�g���o�^����Ă��Ȃ�'
  end
  
  # lookup �̃e�X�g (���m�̃e���v���[�g)
  public
  def test_lookup_known_template
    Lucie::Template.clear
    template = template( 'KNOWN TEMPLATE', Lucie::BooleanTemplate )
    assert_equal template, Lucie::Template::lookup( 'KNOWN TEMPLATE', Lucie::BooleanTemplate ), '�e���v���[�g���o�^����Ă��Ȃ�'
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: