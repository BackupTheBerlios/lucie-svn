#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$KCODE = 'SJIS'
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
    assert_equal NoteTemplate, Lucie::Template.lookup( 'lucie-vmsetup/hello' ).template_type
  end
  
  # �e���v���[�g 'lucie-vmsetup/hello' �� 'Description:' �t�B�[���h���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_template_hello_description
    assert_equal 'Hello!', Lucie::Template.lookup( 'lucie-vmsetup/hello' ).short_description
    assert_equal 'Welcome to Lucie VM setup wizard.', Lucie::Template.lookup( 'lucie-vmsetup/hello' ).extended_description
  end
  
  # �e���v���[�g 'lucie-vmsetup/hello' �� 'Description-ja:' �t�B�[���h���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_template_hello_description_ja
    assert_equal '����ɂ���', Lucie::Template.lookup( 'lucie-vmsetup/hello' ).short_description_ja
    assert_equal 'Lucie VM �̃Z�b�g�A�b�v�E�B�U�[�h�ւ悤����', Lucie::Template.lookup( 'lucie-vmsetup/hello' ).extended_description_ja
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
    assert_equal StringTemplate, Lucie::Template.lookup( 'lucie-vmsetup/num-nodes' ).template_type
  end
  
  # �e���v���[�g 'lucie-vmsetup/num-nodes' �� 'Description-ja:' �t�B�[���h���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_template_num_nodes_description_ja
    assert_equal 'VM �m�[�h�䐔�̑I���ł�', Lucie::Template.lookup( 'lucie-vmsetup/num-nodes' ).short_description_ja
    assert_equal '�g�p������ VM �̑䐔�����Ă�������', Lucie::Template.lookup( 'lucie-vmsetup/num-nodes' ).extended_description_ja
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
    assert_equal Lucie::BooleanTemplate, Lucie::Template.lookup( 'lucie-vmsetup/use-network' ).template_type
  end
  
  # �e���v���[�g 'lucie-vmsetup/use-network' �� 'Default:' �t�B�[���h���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_template_use_network_default
    assert_equal 'false', Lucie::Template.lookup( 'lucie-vmsetup/use-network' ).default
  end
  
  # �e���v���[�g 'lucie-vmsetup/use-network' �� 'Description-ja:' �t�B�[���h���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_template_use_network_description_ja
    assert_equal '�m�[�h�̃l�b�g���[�N', Lucie::Template.lookup( 'lucie-vmsetup/use-network' ).short_description_ja
    assert_equal '�m�[�h�̓l�b�g���[�N�ɂȂ���܂����H', Lucie::Template.lookup( 'lucie-vmsetup/use-network' ).extended_description_ja
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
    assert_equal StringTemplate, Lucie::Template.lookup( 'lucie-vmsetup/ip' ).template_type
  end
  
  # �e���v���[�g 'lucie-vmsetup/ip' �� 'Description-ja:' �t�B�[���h���������ݒ肳��Ă��邩�ǂ������m�F
  def test_template_ip_description_ja
    assert_equal '�m�[�h�� ip �A�h���X', Lucie::Template.lookup( 'lucie-vmsetup/ip' ).short_description_ja
    assert_equal '�m�[�h�� IP �A�h���X�́H', Lucie::Template.lookup( 'lucie-vmsetup/ip' ).extended_description_ja
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
    assert_equal StringTemplate, Lucie::Template.lookup( 'lucie-vmsetup/memory-size' ).template_type
  end
  
  # �e���v���[�g 'lucie-vmsetup/memory-size' �� 'Description-ja:' �t�B�[���h���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_template_memory_size_description_ja
    assert_equal '�m�[�h�̃������e��', Lucie::Template.lookup( 'lucie-vmsetup/memory-size' ).short_description_ja
    assert_equal '�g�p�������������e�ʂ���͂��Ă������� (�P��: MB)', Lucie::Template.lookup( 'lucie-vmsetup/memory-size' ).extended_description_ja
  end
  
  ###################################################################################################
  # �e���v���[�g 'lucie-vmsetup/harddisk-size' �̃e�X�g
  ###################################################################################################

  # �e���v���[�g 'lucie-vmsetup/harddisk-size' ���o�^����Ă��邱�Ƃ��m�F
  public
  def test_template_harddisk_size_registered
    assert Lucie::Template.template_defined?( 'lucie-vmsetup/harddisk-size' )
  end
  
  # �e���v���[�g 'lucie-vmsetup/harddisk-size' �� 'Type:' �t�B�[���h���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_template_harddisk_size_type
    assert_equal StringTemplate, Lucie::Template.lookup( 'lucie-vmsetup/harddisk-size' ).template_type
  end
  
  # �e���v���[�g 'lucie-vmsetup/harddisk-size' �� 'Description-ja:' �t�B�[���h���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_template_harddisk_size_description_ja
    assert_equal '�m�[�h�̃n�[�h�f�B�X�N�e��', Lucie::Template.lookup( 'lucie-vmsetup/harddisk-size' ).short_description_ja
    assert_equal '�g�p�������n�[�h�f�B�X�N�e�ʂ����Ă������� (�P��: MB)', Lucie::Template.lookup( 'lucie-vmsetup/harddisk-size' ).extended_description_ja
  end
  
  ###################################################################################################
  # �e���v���[�g 'lucie-vmsetup/vm-type' �̃e�X�g
  ###################################################################################################

  # �e���v���[�g 'lucie-vmsetup/vm-type' ���o�^����Ă��邱�Ƃ��m�F
  public
  def test_template_vm_type_registered
    assert Lucie::Template.template_defined?( 'lucie-vmsetup/vm-type' )
  end
  
  # �e���v���[�g 'lucie-vmsetup/vm-type' �� 'Type:' �t�B�[���h���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_template_vm_type_type
    assert_equal SelectTemplate, Lucie::Template.lookup( 'lucie-vmsetup/vm-type' ).template_type
  end  
  
  # �e���v���[�g 'lucie-vmsetup/vm-type' �� 'Choices:' �t�B�[���h���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_template_vm_type_choices
    assert_equal ['xen', 'umlinux', 'colinux', 'vmware'], Lucie::Template.lookup( 'lucie-vmsetup/vm-type' ).choices
  end

  # �e���v���[�g 'lucie-vmsetup/vm-type' �� 'Description-ja:' �t�B�[���h���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_template_vm_type_description_ja
    assert_equal '�g�p���� VM �̎��', Lucie::Template.lookup( 'lucie-vmsetup/vm-type' ).short_description_ja
    assert_equal '�g�p���� VM ��I�����Ă�������', Lucie::Template.lookup( 'lucie-vmsetup/vm-type' ).extended_description_ja
  end 
  
  ###################################################################################################
  # �e���v���[�g 'lucie-vmsetup/distro' �̃e�X�g
  ###################################################################################################

  # �e���v���[�g 'lucie-vmsetup/distro' ���o�^����Ă��邱�Ƃ��m�F
  public
  def test_template_os_registered
    assert Lucie::Template.template_defined?( 'lucie-vmsetup/distro' )
  end
  
  # �e���v���[�g 'lucie-vmsetup/distro' �� 'Type:' �t�B�[���h���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_template_os_type
    assert_equal SelectTemplate, Lucie::Template.lookup( 'lucie-vmsetup/distro' ).template_type
    
  end
  
  public
  def test_template_os_type_choices
    assert_equal ['debian (woody)', 'debian (sarge)', 'redhat7.3'], Lucie::Template.lookup( 'lucie-vmsetup/distro' ).choices
  end
  
  # �e���v���[�g 'lucie-vmsetup/distro' �� 'Description-ja:' �t�B�[���h���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_template_distro_description_ja
    assert_equal '�g�p����f�B�X�g���r���[�V�����̑I��', Lucie::Template.lookup( 'lucie-vmsetup/distro' ).short_description_ja
    assert_equal '�g�p����f�B�X�g���r���[�V������I�����Ă�������', Lucie::Template.lookup( 'lucie-vmsetup/distro' ).extended_description_ja
  end
  
  ###################################################################################################
  # �e���v���[�g 'lucie-vmsetup/application' �̃e�X�g
  ###################################################################################################
  
  # �e���v���[�g 'lucie-vmsetup/application' ���o�^����Ă��邱�Ƃ��m�F
  public
  def test_template_application_registered
    assert Lucie::Template.template_defined?( 'lucie-vmsetup/application' )
  end
  
  # �e���v���[�g 'lucie-vmsetup/application' �� 'Type:' �t�B�[���h���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_template_application_type
    assert_equal MultiselectTemplate, Lucie::Template.lookup( 'lucie-vmsetup/application' ).template_type
  end
  
  # �e���v���[�g 'lucie-vmsetup/application' �� 'Choices:' �t�B�[���h���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_template_application_choices
    assert_equal ['ruby', 'perl', 'java'], Lucie::Template.lookup( 'lucie-vmsetup/application' ).choices
  end

  # �e���v���[�g 'lucie-vmsetup/application' �� 'Description-ja:' �t�B�[���h���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_template_application_description_ja
    assert_equal '�g�p����A�v���P�[�V�����̑I��', Lucie::Template.lookup( 'lucie-vmsetup/application' ).short_description_ja
    assert_equal '�g�p����A�v���P�[�V������I�����Ă�������', Lucie::Template.lookup( 'lucie-vmsetup/application' ).extended_description_ja
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
