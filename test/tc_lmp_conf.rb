#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$KCODE = 'SJIS'
$LOAD_PATH.unshift './lib'

require 'test/unit'

# test/lmp_conf/lucie-vm を LMP 設定ファイルとして読み込み、
# Template や Question がきちんと登録できるかどうかをテスト。
class TC_LMP_Conf < Test::Unit::TestCase
  public
  def setup
    require 'test/lmp_conf/lucie-vm'
  end
  
  ###################################################################################################
  # テンプレート 'lucie-vmsetup/hello' のテスト
  ###################################################################################################
  
  # テンプレート 'lucie-vmsetup/hello' が登録されていることを確認
  public
  def test_template_hello_registered
    assert Lucie::Template.template_defined?( 'lucie-vmsetup/hello' )
  end
  
  # テンプレート 'lucie-vmsetup/hello' の 'Type:' フィールドが正しく設定されているかどうかを確認
  public
  def test_template_hello_type
    assert_equal NoteTemplate, Lucie::Template.lookup( 'lucie-vmsetup/hello' ).template_type
  end
  
  # テンプレート 'lucie-vmsetup/hello' の 'Description:' フィールドが正しく設定されているかどうかを確認
  public
  def test_template_hello_description
    assert_equal 'Hello!', Lucie::Template.lookup( 'lucie-vmsetup/hello' ).short_description
    assert_equal 'Welcome to Lucie VM setup wizard.', Lucie::Template.lookup( 'lucie-vmsetup/hello' ).extended_description
  end
  
  # テンプレート 'lucie-vmsetup/hello' の 'Description-ja:' フィールドが正しく設定されているかどうかを確認
  public
  def test_template_hello_description_ja
    assert_equal 'こんにちは', Lucie::Template.lookup( 'lucie-vmsetup/hello' ).short_description_ja
    assert_equal 'Lucie VM のセットアップウィザードへようこそ', Lucie::Template.lookup( 'lucie-vmsetup/hello' ).extended_description_ja
  end
  
  ###################################################################################################
  # テンプレート 'lucie-vmsetup/num-nodes' のテスト
  ###################################################################################################
  
  # テンプレート 'lucie-vmsetup/num-nodes' が登録されていることを確認
  public
  def test_template_num_nodes_registered
    assert Lucie::Template.template_defined?( 'lucie-vmsetup/num-nodes' )
  end
  
  # テンプレート 'lucie-vmsetup/num-nodes' の 'Type:' フィールドが正しく設定されているかどうかを確認
  public
  def test_template_num_nodes_type
    assert_equal StringTemplate, Lucie::Template.lookup( 'lucie-vmsetup/num-nodes' ).template_type
  end
  
  # テンプレート 'lucie-vmsetup/num-nodes' の 'Description-ja:' フィールドが正しく設定されているかどうかを確認
  public
  def test_template_num_nodes_description_ja
    assert_equal 'VM ノード台数の選択です', Lucie::Template.lookup( 'lucie-vmsetup/num-nodes' ).short_description_ja
    assert_equal '使用したい VM の台数を入れてください', Lucie::Template.lookup( 'lucie-vmsetup/num-nodes' ).extended_description_ja
  end
  
  ###################################################################################################
  # テンプレート 'lucie-vmsetup/use-network' のテスト
  ###################################################################################################
  
  # テンプレート 'lucie-vmsetup/use-network' が登録されていることを確認
  public
  def test_template_use_network_registered
    assert Lucie::Template.template_defined?( 'lucie-vmsetup/use-network' )
  end
  
  # テンプレート 'lucie-vmsetup/use-network' の 'Type:' フィールドが正しく設定されているかどうかを確認
  public
  def test_template_use_network_type
    assert_equal Lucie::BooleanTemplate, Lucie::Template.lookup( 'lucie-vmsetup/use-network' ).template_type
  end
  
  # テンプレート 'lucie-vmsetup/use-network' の 'Default:' フィールドが正しく設定されているかどうかを確認
  public
  def test_template_use_network_default
    assert_equal 'false', Lucie::Template.lookup( 'lucie-vmsetup/use-network' ).default
  end
  
  # テンプレート 'lucie-vmsetup/use-network' の 'Description-ja:' フィールドが正しく設定されているかどうかを確認
  public
  def test_template_use_network_description_ja
    assert_equal 'ノードのネットワーク', Lucie::Template.lookup( 'lucie-vmsetup/use-network' ).short_description_ja
    assert_equal 'ノードはネットワークにつながりますか？', Lucie::Template.lookup( 'lucie-vmsetup/use-network' ).extended_description_ja
  end
  
  ###################################################################################################
  # テンプレート 'lucie-vmsetup/ip' のテスト
  ###################################################################################################

  # テンプレート 'lucie-vmsetup/ip' が登録されていることを確認
  public
  def test_template_ip_registered
    assert Lucie::Template.template_defined?( 'lucie-vmsetup/ip' )
  end
  
  # テンプレート 'lucie-vmsetup/ip' の 'Type:' フィールドが正しく設定されているかどうかを確認
  public
  def test_template_ip_type
    assert_equal StringTemplate, Lucie::Template.lookup( 'lucie-vmsetup/ip' ).template_type
  end
  
  # テンプレート 'lucie-vmsetup/ip' の 'Description-ja:' フィールドが正しく設定されているかどうかを確認
  def test_template_ip_description_ja
    assert_equal 'ノードの ip アドレス', Lucie::Template.lookup( 'lucie-vmsetup/ip' ).short_description_ja
    assert_equal 'ノードの IP アドレスは？', Lucie::Template.lookup( 'lucie-vmsetup/ip' ).extended_description_ja
  end
  
  ###################################################################################################
  # テンプレート 'lucie-vmsetup/memory-size' のテスト
  ###################################################################################################

  # テンプレート 'lucie-vmsetup/memory-size' が登録されていることを確認
  public
  def test_template_memory_size_registered
    assert Lucie::Template.template_defined?( 'lucie-vmsetup/memory-size' )
  end
  
  # テンプレート 'lucie-vmsetup/memory-size' の 'Type:' フィールドが正しく設定されているかどうかを確認
  public
  def test_template_memory_size_type
    assert_equal StringTemplate, Lucie::Template.lookup( 'lucie-vmsetup/memory-size' ).template_type
  end
  
  # テンプレート 'lucie-vmsetup/memory-size' の 'Description-ja:' フィールドが正しく設定されているかどうかを確認
  public
  def test_template_memory_size_description_ja
    assert_equal 'ノードのメモリ容量', Lucie::Template.lookup( 'lucie-vmsetup/memory-size' ).short_description_ja
    assert_equal '使用したいメモリ容量を入力してください (単位: MB)', Lucie::Template.lookup( 'lucie-vmsetup/memory-size' ).extended_description_ja
  end
  
  ###################################################################################################
  # テンプレート 'lucie-vmsetup/harddisk-size' のテスト
  ###################################################################################################

  # テンプレート 'lucie-vmsetup/harddisk-size' が登録されていることを確認
  public
  def test_template_harddisk_size_registered
    assert Lucie::Template.template_defined?( 'lucie-vmsetup/harddisk-size' )
  end
  
  # テンプレート 'lucie-vmsetup/harddisk-size' の 'Type:' フィールドが正しく設定されているかどうかを確認
  public
  def test_template_harddisk_size_type
    assert_equal StringTemplate, Lucie::Template.lookup( 'lucie-vmsetup/harddisk-size' ).template_type
  end
  
  # テンプレート 'lucie-vmsetup/harddisk-size' の 'Description-ja:' フィールドが正しく設定されているかどうかを確認
  public
  def test_template_harddisk_size_description_ja
    assert_equal 'ノードのハードディスク容量', Lucie::Template.lookup( 'lucie-vmsetup/harddisk-size' ).short_description_ja
    assert_equal '使用したいハードディスク容量を入れてください (単位: MB)', Lucie::Template.lookup( 'lucie-vmsetup/harddisk-size' ).extended_description_ja
  end
  
  ###################################################################################################
  # テンプレート 'lucie-vmsetup/vm-type' のテスト
  ###################################################################################################

  # テンプレート 'lucie-vmsetup/vm-type' が登録されていることを確認
  public
  def test_template_vm_type_registered
    assert Lucie::Template.template_defined?( 'lucie-vmsetup/vm-type' )
  end
  
  # テンプレート 'lucie-vmsetup/vm-type' の 'Type:' フィールドが正しく設定されているかどうかを確認
  public
  def test_template_vm_type_type
    assert_equal SelectTemplate, Lucie::Template.lookup( 'lucie-vmsetup/vm-type' ).template_type
  end  
  
  # テンプレート 'lucie-vmsetup/vm-type' の 'Choices:' フィールドが正しく設定されているかどうかを確認
  public
  def test_template_vm_type_choices
    assert_equal ['xen', 'umlinux', 'colinux', 'vmware'], Lucie::Template.lookup( 'lucie-vmsetup/vm-type' ).choices
  end

  # テンプレート 'lucie-vmsetup/vm-type' の 'Description-ja:' フィールドが正しく設定されているかどうかを確認
  public
  def test_template_vm_type_description_ja
    assert_equal '使用する VM の種類', Lucie::Template.lookup( 'lucie-vmsetup/vm-type' ).short_description_ja
    assert_equal '使用する VM を選択してください', Lucie::Template.lookup( 'lucie-vmsetup/vm-type' ).extended_description_ja
  end 
  
  ###################################################################################################
  # テンプレート 'lucie-vmsetup/distro' のテスト
  ###################################################################################################

  # テンプレート 'lucie-vmsetup/distro' が登録されていることを確認
  public
  def test_template_os_registered
    assert Lucie::Template.template_defined?( 'lucie-vmsetup/distro' )
  end
  
  # テンプレート 'lucie-vmsetup/distro' の 'Type:' フィールドが正しく設定されているかどうかを確認
  public
  def test_template_os_type
    assert_equal SelectTemplate, Lucie::Template.lookup( 'lucie-vmsetup/distro' ).template_type
    
  end
  
  public
  def test_template_os_type_choices
    assert_equal ['debian (woody)', 'debian (sarge)', 'redhat7.3'], Lucie::Template.lookup( 'lucie-vmsetup/distro' ).choices
  end
  
  # テンプレート 'lucie-vmsetup/distro' の 'Description-ja:' フィールドが正しく設定されているかどうかを確認
  public
  def test_template_distro_description_ja
    assert_equal '使用するディストリビューションの選択', Lucie::Template.lookup( 'lucie-vmsetup/distro' ).short_description_ja
    assert_equal '使用するディストリビューションを選択してください', Lucie::Template.lookup( 'lucie-vmsetup/distro' ).extended_description_ja
  end
  
  ###################################################################################################
  # テンプレート 'lucie-vmsetup/application' のテスト
  ###################################################################################################
  
  # テンプレート 'lucie-vmsetup/application' が登録されていることを確認
  public
  def test_template_application_registered
    assert Lucie::Template.template_defined?( 'lucie-vmsetup/application' )
  end
  
  # テンプレート 'lucie-vmsetup/application' の 'Type:' フィールドが正しく設定されているかどうかを確認
  public
  def test_template_application_type
    assert_equal MultiselectTemplate, Lucie::Template.lookup( 'lucie-vmsetup/application' ).template_type
  end
  
  # テンプレート 'lucie-vmsetup/application' の 'Choices:' フィールドが正しく設定されているかどうかを確認
  public
  def test_template_application_choices
    assert_equal ['ruby', 'perl', 'java'], Lucie::Template.lookup( 'lucie-vmsetup/application' ).choices
  end

  # テンプレート 'lucie-vmsetup/application' の 'Description-ja:' フィールドが正しく設定されているかどうかを確認
  public
  def test_template_application_description_ja
    assert_equal '使用するアプリケーションの選択', Lucie::Template.lookup( 'lucie-vmsetup/application' ).short_description_ja
    assert_equal '使用するアプリケーションを選択してください', Lucie::Template.lookup( 'lucie-vmsetup/application' ).extended_description_ja
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
