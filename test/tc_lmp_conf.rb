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
  
  ###################################################################################################
  # �e���v���[�g 'lucie-vmsetup/hello' �̃e�X�g
  ###################################################################################################
  
  # �e���v���[�g 'lucie-vmsetup/hello' ���o�^����Ă��邱�Ƃ��m�F
  public
  def test_template_hello_registered
    assert Lucie::Template.template_defined?( 'lucie-vmsetup/hello' )
  end
  
  # �e���v���[�g 'lucie-vmsetup/hello' �� 'Type:' �t�B�[���h���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_template_hello_type
    assert_equal Template::NOTE, Lucie::Template.lookup( 'lucie-vmsetup/hello' ).template_type
    assert_equal Template::NOTE, Lucie::Template.lookup( 'lucie-vmsetup/hello' )['Type']
  end
  
  # �e���v���[�g 'lucie-vmsetup/hello' �� 'Description:' �t�B�[���h���������ݒ肳��Ă��邩�ǂ������m�F
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
  
  # �e���v���[�g 'lucie-vmsetup/hello' �� 'Description-ja:' �t�B�[���h���������ݒ肳��Ă��邩�ǂ������m�F
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
  
  ###################################################################################################
  # �e���v���[�g 'lucie-vmsetup/num-nodes' �̃e�X�g
  ###################################################################################################
  
  # �e���v���[�g 'lucie-vmsetup/num-nodes' ���o�^����Ă��邱�Ƃ��m�F
  public
  def test_template_num_nodes_registered
    assert Lucie::Template.template_defined?( 'lucie-vmsetup/num-nodes' )
  end
  
  # �e���v���[�g 'lucie-vmsetup/num-nodes' �� 'Type:' �t�B�[���h���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_template_num_nodes_type
    assert_equal Template::STRING, Lucie::Template.lookup( 'lucie-vmsetup/num-nodes' ).template_type
    assert_equal Template::STRING, Lucie::Template.lookup( 'lucie-vmsetup/num-nodes' )['Type']
  end
  
  # �e���v���[�g 'lucie-vmsetup/num-nodes' �� 'Description-ja:' �t�B�[���h���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_template_hello_description_ja
    assert_equal (<<-DESCRIPTION_JA), Lucie::Template.lookup( 'lucie-vmsetup/num-nodes' ).description_ja
VM �m�[�h�䐔�̑I���ł�
�g�p������ VM �̑䐔�����Ă�������
    DESCRIPTION_JA
    assert_equal (<<-DESCRIPTION_JA), Lucie::Template.lookup( 'lucie-vmsetup/num-nodes' )['Description-ja']
VM �m�[�h�䐔�̑I���ł�
�g�p������ VM �̑䐔�����Ă�������
    DESCRIPTION_JA
  end
  
  ###################################################################################################
  # �e���v���[�g 'lucie-vmsetup/use-network' �̃e�X�g
  ###################################################################################################
  
  # �e���v���[�g 'lucie-vmsetup/use-network' ���o�^����Ă��邱�Ƃ��m�F
  public
  def test_template_use_network_registered
    assert Lucie::Template.template_defined?( 'lucie-vmsetup/use-network' )
  end
  
  # �e���v���[�g 'lucie-vmsetup/use-network' �� 'Type:' �t�B�[���h���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_template_use_network_type
    assert_equal Template::BOOLEAN, Lucie::Template.lookup( 'lucie-vmsetup/use-network' ).template_type
    assert_equal Template::BOOLEAN, Lucie::Template.lookup( 'lucie-vmsetup/use-network' )['Type']
  end
  
  # �e���v���[�g 'lucie-vmsetup/use-network' �� 'Default:' �t�B�[���h���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_template_use_network_default
    assert_equal 'no', Lucie::Template.lookup( 'lucie-vmsetup/use-network' ).default
    assert_equal 'no', Lucie::Template.lookup( 'lucie-vmsetup/use-network' )['Default']
  end
  
  # �e���v���[�g 'lucie-vmsetup/use-network' �� 'Description-ja:' �t�B�[���h���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_template_use_network_description_ja
    assert_equal (<<-DESCRIPTION_JA), Lucie::Template.lookup( 'lucie-vmsetup/use-network' ).description_ja
�m�[�h�̃l�b�g���[�N
�m�[�h�̓l�b�g���[�N�ɂȂ���܂����H
    DESCRIPTION_JA
  end
  
  ###################################################################################################
  # �e���v���[�g 'lucie-vmsetup/ip' �̃e�X�g
  ###################################################################################################

  # �e���v���[�g 'lucie-vmsetup/ip' ���o�^����Ă��邱�Ƃ��m�F
  public
  def test_template_ip_registered
    assert Lucie::Template.template_defined?( 'lucie-vmsetup/ip' )
  end
  
  # �e���v���[�g 'lucie-vmsetup/ip' �� 'Type:' �t�B�[���h���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_template_ip_type
    assert_equal Template::STRING, Lucie::Template.lookup( 'lucie-vmsetup/ip' ).template_type
    assert_equal Template::STRING, Lucie::Template.lookup( 'lucie-vmsetup/ip' )['Type']
  end
  
  # �e���v���[�g 'lucie-vmsetup/ip' �� 'Description-ja:' �t�B�[���h���������ݒ肳��Ă��邩�ǂ������m�F
  def test_template_ip_description_ja
    assert_equal (<<-DESCRIPTION_JA), Lucie::Template.lookup( 'lucie-vmsetup/ip' ).description_ja
�m�[�h�� ip �A�h���X
�m�[�h�� IP �A�h���X�́H
    DESCRIPTION_JA
  end
  
  ###################################################################################################
  # �e���v���[�g 'lucie-vmsetup/memory-size' �̃e�X�g
  ###################################################################################################

  # �e���v���[�g 'lucie-vmsetup/memory-size' ���o�^����Ă��邱�Ƃ��m�F
  public
  def test_template_memory_size_registered
    assert Lucie::Template.template_defined?( 'lucie-vmsetup/memory-size' )
  end
  
  # �e���v���[�g 'lucie-vmsetup/memory-size' �� 'Type:' �t�B�[���h���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_template_memory_size_type
    assert_equal Template::STRING, Lucie::Template.lookup( 'lucie-vmsetup/memory-size' ).template_type
    assert_equal Template::STRING, Lucie::Template.lookup( 'lucie-vmsetup/memory-size' )['Type']
  end
  
  # �e���v���[�g 'lucie-vmsetup/memory-size' �� 'Description-ja:' �t�B�[���h���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_template_memory_size_description_ja
    assert_equal (<<-DESCRIPTION_JA), Lucie::Template.lookup( 'lucie-vmsetup/memory-size' ).description_ja
�m�[�h�̃�����
�g�p�������������e�ʂ���͂��Ă������� (�P��: MB)
    DESCRIPTION_JA
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
