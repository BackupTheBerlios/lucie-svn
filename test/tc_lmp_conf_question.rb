#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$KCODE = 'SJIS'
$LOAD_PATH.unshift './lib'

require 'test/unit'

# Template ���o�^�ł��邱�Ƃ��e�X�g
class TC_LMP_Conf_Template < Test::Unit::TestCase
  public
  def setup
    require 'test/lmp_conf/lucie_vm_template'
    require 'test/lmp_conf/lucie_vm_question'
  end
  
  ###################################################################################################
  # ���⍀�� 'lucie-vmsetup/hello' �̃e�X�g
  ###################################################################################################

  # ���⍀�� 'lucie-vmsetup/hello' ���o�^����Ă��邱�Ƃ��m�F
  public
  def test_question_hello_registered
    assert Lucie::Question.question_defined?( 'lucie-vmsetup/hello' )
  end
  
  # ���⍀�� 'lucie-vmsetup/hello' �̃e���v���[�g���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_question_hello_template
    assert_equal 'lucie-vmsetup/hello', Lucie::Question.lookup( 'lucie-vmsetup/hello' ).template.name
  end
  
  # ���⍀�� 'lucie-vmsetup/hello' �� priority ���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_question_hello_priority
    assert_equal Lucie::Question::PRIORITY_MEDIUM, Lucie::Question.lookup( 'lucie-vmsetup/hello' ).priority
  end
  
  # ���⍀�� 'lucie-vmsetup/hello' �� next_question ���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_question_hello_next_question
    assert_equal 'lucie-vmsetup/num-nodes', Lucie::Question.lookup( 'lucie-vmsetup/hello' ).next_question
  end
  
  # ���⍀�� 'lucie-vmsetup/hello' �� first_question ���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_question_hello_first_question
    assert Lucie::Question.lookup( 'lucie-vmsetup/hello' ).first_question
  end  
  
  ###################################################################################################
  # ���⍀�� 'lucie-vmsetup/num-nodes' �̃e�X�g
  ###################################################################################################

  # ���⍀�� 'lucie-vmsetup/num-nodes' ���o�^����Ă��邱�Ƃ��m�F
  public
  def test_question_num_nodes_registered
    assert Lucie::Question.question_defined?( 'lucie-vmsetup/num-nodes' )
  end
  
  # ���⍀�� 'lucie-vmsetup/num-nodes' �̃e���v���[�g���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_question_num_nodes_template
    assert_equal 'lucie-vmsetup/num-nodes', Lucie::Question.lookup( 'lucie-vmsetup/num-nodes' ).template.name
  end
  
  # ���⍀�� 'lucie-vmsetup/num-nodes' �� priority ���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_question_num_nodes_priority
    assert_equal Lucie::Question::PRIORITY_MEDIUM, Lucie::Question.lookup( 'lucie-vmsetup/num-nodes' ).priority
  end 
  
  # ���⍀�� 'lucie-vmsetup/num-nodes' �� next_question ���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_question_num_nodes_next_question
    assert_equal 'lucie-vmsetup/use-network', Lucie::Question.lookup( 'lucie-vmsetup/num-nodes' ).next_question
  end
  
  # ���⍀�� 'lucie-vmsetup/num-nodes' �� first_question ���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_question_num_nodes_first_question
    assert_nil Lucie::Question.lookup( 'lucie-vmsetup/num-nodes' ).first_question
  end

  ###################################################################################################
  # ���⍀�� 'lucie-vmsetup/use-network' �̃e�X�g
  ###################################################################################################

  # ���⍀�� 'lucie-vmsetup/use-network' ���o�^����Ă��邱�Ƃ��m�F
  public
  def test_question_use_network_registered
    assert Lucie::Question.question_defined?( 'lucie-vmsetup/use-network' )
  end
  
  # ���⍀�� 'lucie-vmsetup/use-network' �̃e���v���[�g���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_question_use_network_template
    assert_equal 'lucie-vmsetup/use-network', Lucie::Question.lookup( 'lucie-vmsetup/use-network' ).template.name
  end
  
  # ���⍀�� 'lucie-vmsetup/use-network' �� priority ���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_question_use_network_priority
    assert_equal Lucie::Question::PRIORITY_MEDIUM, Lucie::Question.lookup( 'lucie-vmsetup/use-network' ).priority
  end 
  
  # ���⍀�� 'lucie-vmsetup/use-network' �� next_question ���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_question_use_network_next_question
    assert_equal( {true=>'lucie-vmsetup/ip', false=>'lucie-vmsetup/memory-size'}, Lucie::Question.lookup( 'lucie-vmsetup/use-network' ).next_question )
  end
  
  # ���⍀�� 'lucie-vmsetup/use-network' �� first_question ���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_question_use_network_first_question
    assert_nil Lucie::Question.lookup( 'lucie-vmsetup/use-network' ).first_question
  end

  ###################################################################################################
  # ���⍀�� 'lucie-vmsetup/ip' �̃e�X�g
  ###################################################################################################

  # ���⍀�� 'lucie-vmsetup/ip' ���o�^����Ă��邱�Ƃ��m�F
  public
  def test_question_ip_registered
    assert Lucie::Question.question_defined?( 'lucie-vmsetup/ip' )
  end
  
  # ���⍀�� 'lucie-vmsetup/ip' �̃e���v���[�g���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_question_ip_template
    assert_equal 'lucie-vmsetup/ip', Lucie::Question.lookup( 'lucie-vmsetup/ip' ).template.name
  end

  # ���⍀�� 'lucie-vmsetup/ip' �� priority ���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_question_ip_priority
    assert_equal Lucie::Question::PRIORITY_MEDIUM, Lucie::Question.lookup( 'lucie-vmsetup/ip' ).priority
  end  
  
  # ���⍀�� 'lucie-vmsetup/ip' �� next_question ���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_question_ip_next_question
    assert_equal 'lucie-vmsetup/memory-size', Lucie::Question.lookup( 'lucie-vmsetup/ip' ).next_question
  end
  
  # ���⍀�� 'lucie-vmsetup/ip' �� first_question ���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_question_ip_first_question
    assert_nil Lucie::Question.lookup( 'lucie-vmsetup/ip' ).first_question
  end  

  ###################################################################################################
  # ���⍀�� 'lucie-vmsetup/memory-size' �̃e�X�g
  ###################################################################################################

  # ���⍀�� 'lucie-vmsetup/memory-size' ���o�^����Ă��邱�Ƃ��m�F
  public
  def test_question_memory_size_registered
    assert Lucie::Question.question_defined?( 'lucie-vmsetup/memory-size' )
  end

  # ���⍀�� 'lucie-vmsetup/memory-size' �̃e���v���[�g���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_question_memory_size_template
    assert_equal 'lucie-vmsetup/memory-size', Lucie::Question.lookup( 'lucie-vmsetup/memory-size' ).template.name
  end
  
  # ���⍀�� 'lucie-vmsetup/memory-size' �� priority ���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_question_memory_size_priority
    assert_equal Lucie::Question::PRIORITY_MEDIUM, Lucie::Question.lookup( 'lucie-vmsetup/memory-size' ).priority
  end
  
  # ���⍀�� 'lucie-vmsetup/memory-size' �� next_question ���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_question_memory_size_next_question
    assert_equal 'lucie-vmsetup/harddisk-size', Lucie::Question.lookup( 'lucie-vmsetup/memory-size' ).next_question
  end
  
  # ���⍀�� 'lucie-vmsetup/memory-size' �� first_question ���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_question_memory_size_first_question
    assert_nil Lucie::Question.lookup( 'lucie-vmsetup/memory-size' ).first_question
  end    
  
  ###################################################################################################
  # ���⍀�� 'lucie-vmsetup/harddisk-size' �̃e�X�g
  ###################################################################################################

  # ���⍀�� 'lucie-vmsetup/harddisk-size' ���o�^����Ă��邱�Ƃ��m�F
  public
  def test_question_harddisk_size_registered
    assert Lucie::Question.question_defined?( 'lucie-vmsetup/harddisk-size' )
  end
  
  # ���⍀�� 'lucie-vmsetup/harddisk-size' �̃e���v���[�g���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_question_harddisk_size_template
    assert_equal 'lucie-vmsetup/harddisk-size', Lucie::Question.lookup( 'lucie-vmsetup/harddisk-size' ).template.name
  end
  
  # ���⍀�� 'lucie-vmsetup/harddisk-size' �� priority ���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_question_harddisk_size_priority
    assert_equal Lucie::Question::PRIORITY_MEDIUM, Lucie::Question.lookup( 'lucie-vmsetup/harddisk-size' ).priority
  end
  
  # ���⍀�� 'lucie-vmsetup/harddisk-size' �� next_question ���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_question_harddisk_size_next_question
    assert_equal 'lucie-vmsetup/vm-type', Lucie::Question.lookup( 'lucie-vmsetup/harddisk-size' ).next_question
  end
  
  # ���⍀�� 'lucie-vmsetup/harddisk-size' �� first_question ���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_question_harddisk_size_first_question
    assert_nil Lucie::Question.lookup( 'lucie-vmsetup/harddisk-size' ).first_question
  end    
  
  ###################################################################################################
  # ���⍀�� 'lucie-vmsetup/vm-type' �̃e�X�g
  ###################################################################################################

  # ���⍀�� 'lucie-vmsetup/vm-type' ���o�^����Ă��邱�Ƃ��m�F
  public
  def test_question_vm_type_registered
    assert Lucie::Question.question_defined?( 'lucie-vmsetup/vm-type' )
  end

  # ���⍀�� 'lucie-vmsetup/vm-type' �̃e���v���[�g���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_question_vm_type_template
    assert_equal 'lucie-vmsetup/vm-type', Lucie::Question.lookup( 'lucie-vmsetup/vm-type' ).template.name
  end
  
  # ���⍀�� 'lucie-vmsetup/vm-type' �� priority ���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_question_vm_type_priority
    assert_equal Lucie::Question::PRIORITY_MEDIUM, Lucie::Question.lookup( 'lucie-vmsetup/vm-type' ).priority
  end
  
  # ���⍀�� 'lucie-vmsetup/vm-type' �� next_question ���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_question_vm_type_next_question
    assert_equal 'lucie-vmsetup/distro', Lucie::Question.lookup( 'lucie-vmsetup/vm-type' ).next_question
  end
  
  # ���⍀�� 'lucie-vmsetup/vm-type' �� first_question ���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_question_vm_type_first_question
    assert_nil Lucie::Question.lookup( 'lucie-vmsetup/vm-type' ).first_question
  end

  ###################################################################################################
  # ���⍀�� 'lucie-vmsetup/distro' �̃e�X�g
  ###################################################################################################

  # ���⍀�� 'lucie-vmsetup/distro' ���o�^����Ă��邱�Ƃ��m�F
  public
  def test_question_distro_registered
    assert Lucie::Question.question_defined?( 'lucie-vmsetup/distro' )
  end
  
  # ���⍀�� 'lucie-vmsetup/distro' �̃e���v���[�g���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_question_distro_template
    assert_equal 'lucie-vmsetup/distro', Lucie::Question.lookup( 'lucie-vmsetup/distro' ).template.name
  end

  # ���⍀�� 'lucie-vmsetup/distro' �� priority ���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_question_distro_priority
    assert_equal Lucie::Question::PRIORITY_MEDIUM, Lucie::Question.lookup( 'lucie-vmsetup/distro' ).priority
  end
  
  # ���⍀�� 'lucie-vmsetup/distro' �� next_question ���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_question_distro_next_question
    assert_equal 'lucie-vmsetup/application', Lucie::Question.lookup( 'lucie-vmsetup/distro' ).next_question
  end
  
  # ���⍀�� 'lucie-vmsetup/distro' �� first_question ���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_question_distro_first_question
    assert_nil Lucie::Question.lookup( 'lucie-vmsetup/distro' ).first_question
  end
  
  ###################################################################################################
  # ���⍀�� 'lucie-vmsetup/application' �̃e�X�g
  ###################################################################################################

  # ���⍀�� 'lucie-vmsetup/application' ���o�^����Ă��邱�Ƃ��m�F
  public
  def test_question_application_registered
    assert Lucie::Question.question_defined?( 'lucie-vmsetup/application' )
  end
  
  # ���⍀�� 'lucie-vmsetup/application' �̃e���v���[�g���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_question_application_template
    assert_equal 'lucie-vmsetup/application', Lucie::Question.lookup( 'lucie-vmsetup/application' ).template.name
  end
  
  # ���⍀�� 'lucie-vmsetup/application' �� priority ���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_question_application_priority
    assert_equal Lucie::Question::PRIORITY_MEDIUM, Lucie::Question.lookup( 'lucie-vmsetup/application' ).priority
  end
  
  # ���⍀�� 'lucie-vmsetup/application' �� next_question ���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_question_distro_next_question
    assert_nil Lucie::Question.lookup( 'lucie-vmsetup/application' ).next_question
  end
  
  # ���⍀�� 'lucie-vmsetup/application' �� first_question ���������ݒ肳��Ă��邩�ǂ������m�F
  public
  def test_question_distro_first_question
    assert_nil Lucie::Question.lookup( 'lucie-vmsetup/application' ).first_question
  end  
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: