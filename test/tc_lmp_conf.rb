#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'test/unit'

# test/lmp_conf/lucie-vm �� LMP �ݒ�t�@�C���Ƃ��ēǂݍ��݁A
# Template �� Question ��������Ɠo�^�ł��邩�ǂ������e�X�g�B
class TC_LMP_Conf < Test::Unit::TestCase
  public
  def setup
    require 'test/lmp_conf/lucie-vm'
  end
  
  # �^�X�N 'lucie-vmsetup/hello' ���o�^����Ă��邱�Ƃ��m�F
  public
  def test_template_hello_registered
    assert Lucie::Template.template_defined?( 'lucie-vmsetup/hello' )
  end
  
  # �^�X�N 'lucie-vmsetup/hello' �� 'Type:' �t�B�[���h���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_template_hello_type
    assert_equal Template::NOTE, Lucie::Template.lookup( 'lucie-vmsetup/hello' ).template_type
    assert_equal Template::NOTE, Lucie::Template.lookup( 'lucie-vmsetup/hello' )['Type']
  end
  
  # �^�X�N 'lucie-vmsetup/hello' �� 'Description:' �t�B�[���h���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_template_hello_description
    assert_equal (<<-DESCRIPTION), Lucie::Template.lookup( 'lucie-vmsetup/hello' ).description
Hello!
Welcome to Lucie VM setup wizard.
    DESCRIPTION
    assert_equal (<<-DESCRIPTION), Lucie::Template.lookup( 'lucie-vmsetup/hello' )['Description']
Hello!
Welcome to Lucie VM setup wizard.
    DESCRIPTION
  end
  
  # �^�X�N 'lucie-vmsetup/hello' �� 'Description-ja:' �t�B�[���h���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_template_hello_description_ja
    assert_equal (<<-DESCRIPTION_JA), Lucie::Template.lookup( 'lucie-vmsetup/hello' ).description_ja
����ɂ���
Lucie VM �̃Z�b�g�A�b�v�E�B�U�[�h�ւ悤����
    DESCRIPTION_JA
    assert_equal (<<-DESCRIPTION_JA), Lucie::Template.lookup( 'lucie-vmsetup/hello' )['Description-ja']
����ɂ���
Lucie VM �̃Z�b�g�A�b�v�E�B�U�[�h�ւ悤����
    DESCRIPTION_JA
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
