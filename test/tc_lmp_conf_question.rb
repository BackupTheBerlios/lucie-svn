#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$KCODE = 'SJIS'
$LOAD_PATH.unshift './lib'

require 'test/unit'

# Template が登録できることをテスト
class TC_LMP_Conf_Template < Test::Unit::TestCase
  public
  def setup
    require 'test/lmp_conf/lucie_vm_template'
    require 'test/lmp_conf/lucie_vm_question'
  end
  
  ###################################################################################################
  # 質問項目 'lucie-vmsetup/hello' のテスト
  ###################################################################################################

  # 質問項目 'lucie-vmsetup/hello' が登録されていることを確認
  public
  def test_question_hello_registered
    assert Lucie::Question.question_defined?( 'lucie-vmsetup/hello' )
  end
  
  # 質問項目 'lucie-vmsetup/hello' のテンプレートが正しく設定されているかどうかを確認
  public
  def test_question_hello_template
    assert_equal 'lucie-vmsetup/hello', Lucie::Question.lookup( 'lucie-vmsetup/hello' ).template.name
  end
  
  # 質問項目 'lucie-vmsetup/hello' の priority が正しく設定されているかどうかを確認
  public
  def test_question_hello_priority
    assert_equal Lucie::Question::PRIORITY_MEDIUM, Lucie::Question.lookup( 'lucie-vmsetup/hello' ).priority
  end
  
  # 質問項目 'lucie-vmsetup/hello' の next_question が正しく設定されているかどうかを確認
  public
  def test_question_hello_next_question
    assert_equal 'lucie-vmsetup/num-nodes', Lucie::Question.lookup( 'lucie-vmsetup/hello' ).next_question
  end
  
  # 質問項目 'lucie-vmsetup/hello' の first_question が正しく設定されているかどうかを確認
  public
  def test_question_hello_first_question
    assert Lucie::Question.lookup( 'lucie-vmsetup/hello' ).first_question
  end  
  
  ###################################################################################################
  # 質問項目 'lucie-vmsetup/num-nodes' のテスト
  ###################################################################################################

  # 質問項目 'lucie-vmsetup/num-nodes' が登録されていることを確認
  public
  def test_question_num_nodes_registered
    assert Lucie::Question.question_defined?( 'lucie-vmsetup/num-nodes' )
  end
  
  # 質問項目 'lucie-vmsetup/num-nodes' のテンプレートが正しく設定されているかどうかを確認
  public
  def test_question_num_nodes_template
    assert_equal 'lucie-vmsetup/num-nodes', Lucie::Question.lookup( 'lucie-vmsetup/num-nodes' ).template.name
  end
  
  # 質問項目 'lucie-vmsetup/num-nodes' の priority が正しく設定されているかどうかを確認
  public
  def test_question_num_nodes_priority
    assert_equal Lucie::Question::PRIORITY_MEDIUM, Lucie::Question.lookup( 'lucie-vmsetup/num-nodes' ).priority
  end 
  
  # 質問項目 'lucie-vmsetup/num-nodes' の next_question が正しく設定されているかどうかを確認
  public
  def test_question_num_nodes_next_question
    assert_equal 'lucie-vmsetup/use-network', Lucie::Question.lookup( 'lucie-vmsetup/num-nodes' ).next_question
  end
  
  # 質問項目 'lucie-vmsetup/num-nodes' の first_question が正しく設定されているかどうかを確認
  public
  def test_question_num_nodes_first_question
    assert_nil Lucie::Question.lookup( 'lucie-vmsetup/num-nodes' ).first_question
  end

  ###################################################################################################
  # 質問項目 'lucie-vmsetup/use-network' のテスト
  ###################################################################################################

  # 質問項目 'lucie-vmsetup/use-network' が登録されていることを確認
  public
  def test_question_use_network_registered
    assert Lucie::Question.question_defined?( 'lucie-vmsetup/use-network' )
  end
  
  # 質問項目 'lucie-vmsetup/use-network' のテンプレートが正しく設定されているかどうかを確認
  public
  def test_question_use_network_template
    assert_equal 'lucie-vmsetup/use-network', Lucie::Question.lookup( 'lucie-vmsetup/use-network' ).template.name
  end
  
  # 質問項目 'lucie-vmsetup/use-network' の priority が正しく設定されているかどうかを確認
  public
  def test_question_use_network_priority
    assert_equal Lucie::Question::PRIORITY_MEDIUM, Lucie::Question.lookup( 'lucie-vmsetup/use-network' ).priority
  end 
  
  # 質問項目 'lucie-vmsetup/use-network' の next_question が正しく設定されているかどうかを確認
  public
  def test_question_use_network_next_question
    assert_equal( {true=>'lucie-vmsetup/ip', false=>'lucie-vmsetup/memory-size'}, Lucie::Question.lookup( 'lucie-vmsetup/use-network' ).next_question )
  end
  
  # 質問項目 'lucie-vmsetup/use-network' の first_question が正しく設定されているかどうかを確認
  public
  def test_question_use_network_first_question
    assert_nil Lucie::Question.lookup( 'lucie-vmsetup/use-network' ).first_question
  end

  ###################################################################################################
  # 質問項目 'lucie-vmsetup/ip' のテスト
  ###################################################################################################

  # 質問項目 'lucie-vmsetup/ip' が登録されていることを確認
  public
  def test_question_ip_registered
    assert Lucie::Question.question_defined?( 'lucie-vmsetup/ip' )
  end
  
  # 質問項目 'lucie-vmsetup/ip' のテンプレートが正しく設定されているかどうかを確認
  public
  def test_question_ip_template
    assert_equal 'lucie-vmsetup/ip', Lucie::Question.lookup( 'lucie-vmsetup/ip' ).template.name
  end

  # 質問項目 'lucie-vmsetup/ip' の priority が正しく設定されているかどうかを確認
  public
  def test_question_ip_priority
    assert_equal Lucie::Question::PRIORITY_MEDIUM, Lucie::Question.lookup( 'lucie-vmsetup/ip' ).priority
  end  
  
  # 質問項目 'lucie-vmsetup/ip' の next_question が正しく設定されているかどうかを確認
  public
  def test_question_ip_next_question
    assert_equal 'lucie-vmsetup/memory-size', Lucie::Question.lookup( 'lucie-vmsetup/ip' ).next_question
  end
  
  # 質問項目 'lucie-vmsetup/ip' の first_question が正しく設定されているかどうかを確認
  public
  def test_question_ip_first_question
    assert_nil Lucie::Question.lookup( 'lucie-vmsetup/ip' ).first_question
  end  

  ###################################################################################################
  # 質問項目 'lucie-vmsetup/memory-size' のテスト
  ###################################################################################################

  # 質問項目 'lucie-vmsetup/memory-size' が登録されていることを確認
  public
  def test_question_memory_size_registered
    assert Lucie::Question.question_defined?( 'lucie-vmsetup/memory-size' )
  end

  # 質問項目 'lucie-vmsetup/memory-size' のテンプレートが正しく設定されているかどうかを確認
  public
  def test_question_memory_size_template
    assert_equal 'lucie-vmsetup/memory-size', Lucie::Question.lookup( 'lucie-vmsetup/memory-size' ).template.name
  end
  
  # 質問項目 'lucie-vmsetup/memory-size' の priority が正しく設定されているかどうかを確認
  public
  def test_question_memory_size_priority
    assert_equal Lucie::Question::PRIORITY_MEDIUM, Lucie::Question.lookup( 'lucie-vmsetup/memory-size' ).priority
  end
  
  # 質問項目 'lucie-vmsetup/memory-size' の next_question が正しく設定されているかどうかを確認
  public
  def test_question_memory_size_next_question
    assert_equal 'lucie-vmsetup/harddisk-size', Lucie::Question.lookup( 'lucie-vmsetup/memory-size' ).next_question
  end
  
  # 質問項目 'lucie-vmsetup/memory-size' の first_question が正しく設定されているかどうかを確認
  public
  def test_question_memory_size_first_question
    assert_nil Lucie::Question.lookup( 'lucie-vmsetup/memory-size' ).first_question
  end    
  
  ###################################################################################################
  # 質問項目 'lucie-vmsetup/harddisk-size' のテスト
  ###################################################################################################

  # 質問項目 'lucie-vmsetup/harddisk-size' が登録されていることを確認
  public
  def test_question_harddisk_size_registered
    assert Lucie::Question.question_defined?( 'lucie-vmsetup/harddisk-size' )
  end
  
  # 質問項目 'lucie-vmsetup/harddisk-size' のテンプレートが正しく設定されているかどうかを確認
  public
  def test_question_harddisk_size_template
    assert_equal 'lucie-vmsetup/harddisk-size', Lucie::Question.lookup( 'lucie-vmsetup/harddisk-size' ).template.name
  end
  
  # 質問項目 'lucie-vmsetup/harddisk-size' の priority が正しく設定されているかどうかを確認
  public
  def test_question_harddisk_size_priority
    assert_equal Lucie::Question::PRIORITY_MEDIUM, Lucie::Question.lookup( 'lucie-vmsetup/harddisk-size' ).priority
  end
  
  # 質問項目 'lucie-vmsetup/harddisk-size' の next_question が正しく設定されているかどうかを確認
  public
  def test_question_harddisk_size_next_question
    assert_equal 'lucie-vmsetup/vm-type', Lucie::Question.lookup( 'lucie-vmsetup/harddisk-size' ).next_question
  end
  
  # 質問項目 'lucie-vmsetup/harddisk-size' の first_question が正しく設定されているかどうかを確認
  public
  def test_question_harddisk_size_first_question
    assert_nil Lucie::Question.lookup( 'lucie-vmsetup/harddisk-size' ).first_question
  end    
  
  ###################################################################################################
  # 質問項目 'lucie-vmsetup/vm-type' のテスト
  ###################################################################################################

  # 質問項目 'lucie-vmsetup/vm-type' が登録されていることを確認
  public
  def test_question_vm_type_registered
    assert Lucie::Question.question_defined?( 'lucie-vmsetup/vm-type' )
  end

  # 質問項目 'lucie-vmsetup/vm-type' のテンプレートが正しく設定されているかどうかを確認
  public
  def test_question_vm_type_template
    assert_equal 'lucie-vmsetup/vm-type', Lucie::Question.lookup( 'lucie-vmsetup/vm-type' ).template.name
  end
  
  # 質問項目 'lucie-vmsetup/vm-type' の priority が正しく設定されているかどうかを確認
  public
  def test_question_vm_type_priority
    assert_equal Lucie::Question::PRIORITY_MEDIUM, Lucie::Question.lookup( 'lucie-vmsetup/vm-type' ).priority
  end
  
  # 質問項目 'lucie-vmsetup/vm-type' の next_question が正しく設定されているかどうかを確認
  public
  def test_question_vm_type_next_question
    assert_equal 'lucie-vmsetup/distro', Lucie::Question.lookup( 'lucie-vmsetup/vm-type' ).next_question
  end
  
  # 質問項目 'lucie-vmsetup/vm-type' の first_question が正しく設定されているかどうかを確認
  public
  def test_question_vm_type_first_question
    assert_nil Lucie::Question.lookup( 'lucie-vmsetup/vm-type' ).first_question
  end

  ###################################################################################################
  # 質問項目 'lucie-vmsetup/distro' のテスト
  ###################################################################################################

  # 質問項目 'lucie-vmsetup/distro' が登録されていることを確認
  public
  def test_question_distro_registered
    assert Lucie::Question.question_defined?( 'lucie-vmsetup/distro' )
  end
  
  # 質問項目 'lucie-vmsetup/distro' のテンプレートが正しく設定されているかどうかを確認
  public
  def test_question_distro_template
    assert_equal 'lucie-vmsetup/distro', Lucie::Question.lookup( 'lucie-vmsetup/distro' ).template.name
  end

  # 質問項目 'lucie-vmsetup/distro' の priority が正しく設定されているかどうかを確認
  public
  def test_question_distro_priority
    assert_equal Lucie::Question::PRIORITY_MEDIUM, Lucie::Question.lookup( 'lucie-vmsetup/distro' ).priority
  end
  
  # 質問項目 'lucie-vmsetup/distro' の next_question が正しく設定されているかどうかを確認
  public
  def test_question_distro_next_question
    assert_equal 'lucie-vmsetup/application', Lucie::Question.lookup( 'lucie-vmsetup/distro' ).next_question
  end
  
  # 質問項目 'lucie-vmsetup/distro' の first_question が正しく設定されているかどうかを確認
  public
  def test_question_distro_first_question
    assert_nil Lucie::Question.lookup( 'lucie-vmsetup/distro' ).first_question
  end
  
  ###################################################################################################
  # 質問項目 'lucie-vmsetup/application' のテスト
  ###################################################################################################

  # 質問項目 'lucie-vmsetup/application' が登録されていることを確認
  public
  def test_question_application_registered
    assert Lucie::Question.question_defined?( 'lucie-vmsetup/application' )
  end
  
  # 質問項目 'lucie-vmsetup/application' のテンプレートが正しく設定されているかどうかを確認
  public
  def test_question_application_template
    assert_equal 'lucie-vmsetup/application', Lucie::Question.lookup( 'lucie-vmsetup/application' ).template.name
  end
  
  # 質問項目 'lucie-vmsetup/application' の priority が正しく設定されているかどうかを確認
  public
  def test_question_application_priority
    assert_equal Lucie::Question::PRIORITY_MEDIUM, Lucie::Question.lookup( 'lucie-vmsetup/application' ).priority
  end
  
  # 質問項目 'lucie-vmsetup/application' の next_question が正しく設定されているかどうかを確認
  public
  def test_question_distro_next_question
    assert_nil Lucie::Question.lookup( 'lucie-vmsetup/application' ).next_question
  end
  
  # 質問項目 'lucie-vmsetup/application' の first_question が正しく設定されているかどうかを確認
  public
  def test_question_distro_first_question
    assert_nil Lucie::Question.lookup( 'lucie-vmsetup/application' ).first_question
  end  
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: