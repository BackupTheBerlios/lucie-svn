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
    template 'TEST/TEMPLATE#1'
    template 'TEST/TEMPLATE#2'
    template 'TEST/TEMPLATE#3'
    
    assert_equal 3, Lucie::Template.templates.size, '�o�^����Ă���e���v���[�g�̐����Ⴄ'
    assert_equal 'TEST/TEMPLATE#1', Lucie::Template.templates[0].name, '�e���v���[�g�̖��O���Ⴄ'
    assert_kind_of Lucie::Template, Lucie::Template.templates[0], '�e���v���[�g�̌^���Ⴄ'
    assert_equal 'TEST/TEMPLATE#2', Lucie::Template.templates[1].name, '�e���v���[�g�̖��O���Ⴄ'
    assert_kind_of Lucie::Template, Lucie::Template.templates[1], '�e���v���[�g�̌^���Ⴄ'
    assert_equal 'TEST/TEMPLATE#3', Lucie::Template.templates[2].name, '�e���v���[�g�̖��O���Ⴄ'
    assert_kind_of Lucie::Template, Lucie::Template.templates[2], '�e���v���[�g�̌^���Ⴄ'
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
    template( 'TEST TEMPLATE' )
    assert Lucie::Template.template_defined?( 'TEST TEMPLATE' ), '�e���v���[�g���o�^����Ă��Ȃ�'
  end
  
  public
  def test_template
    assert_kind_of Lucie::Template, template( 'LUCIE/OVERVIEW' ), '�e���v���[�g�̌^���Ⴄ'
  end
  
  # ���m�̃e���v���[�g�� lookup ���A�V�����e���v���[�g���ł��邱�Ƃ��m�F
  public
  def test_lookup_unknown_template
    Lucie::Template.clear
    template = Lucie::Template::lookup( 'UNKNOWN TEMPLATE' )
    assert_kind_of Lucie::Template, template, '�e���v���[�g�� Type ���Ⴄ'
    assert_equal 'UNKNOWN TEMPLATE', template.name, '�e���v���[�g�̖��O���Ⴄ'
  end
  
  # ���m�̃e���v���[�g�� lookup �ł��邱�Ƃ��m�F
  public
  def test_lookup_known_template
    Lucie::Template.clear
    known_template = template( 'KNOWN TEMPLATE' )
    assert_equal known_template, Lucie::Template::lookup( 'KNOWN TEMPLATE' ), '�e���v���[�g���o�^����Ă��Ȃ�'
    assert_equal 'KNOWN TEMPLATE', known_template.name, '�e���v���[�g�̖��O���Ⴄ'
  end
  
  ###############################################################################################
  # Template �̕ϐ�����p���\�b�h�̃e�X�g
  ###############################################################################################
  
  public
  def test_type
    boolean_template = \
    Lucie::Template.new( 'TEST BOOLEAN TEMPLATE' ).enhance do |template|
      template.template_type = Lucie::BooleanTemplate
    end    
    assert_kind_of Lucie::BooleanTemplate, boolean_template, '�e���v���[�g�̌^���Ⴄ'
    assert_equal Lucie::BooleanTemplate, boolean_template.template_type, '�e���v���[�g�̌^���Ⴄ'
  end
  
  public
  def test_default
    _template = \
    Lucie::Template.new( 'hostname' ).enhance do |template|
      template.default = 'debian'
    end    
    assert_equal 'debian', _template.default, 'Deafult: ���Ⴄ'
  end
  
  public
  def test_choices
    _template = \
    Lucie::Template.new( 'hostname' ).enhance do |template|
      template.choices = ['debian workstation', 'debian desktop', 'debian cluster node']
    end    
    assert_equal ['debian workstation', 'debian desktop', 'debian cluster node'], _template.choices, 'Choices: ���Ⴄ'
  end
  
  public
  def test_short_description
    _template = \
    Lucie::Template.new( 'hostname' ).enhance do |template|
      template.short_description = 'unqualified hostname for this computer'
    end    
    assert_equal 'unqualified hostname for this computer', _template.short_description, 'Short description ���Ⴄ'
  end
  
  public
  def test_extended_description
    _template = \
    Lucie::Template.new( 'hostname' ).enhance do |template|
      template.extended_description = (<<-EXTENDED_DESCRIPTION)
This is the name by which this computer will be known on the network. It
has to be a unique name in your domain.
      EXTENDED_DESCRIPTION
    end    
    assert_match( /This is the name by which this computer will be known on the network\. It.*has to be a unique name in your domain\..*/m,
                  _template.extended_description, 'Extended description ���Ⴄ' )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: