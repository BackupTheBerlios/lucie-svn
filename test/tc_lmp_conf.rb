#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

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
    assert_equal Template::NOTE, Lucie::Template.lookup( 'lucie-vmsetup/hello' ).template_type
    assert_equal Template::NOTE, Lucie::Template.lookup( 'lucie-vmsetup/hello' )['Type']
  end
  
  # テンプレート 'lucie-vmsetup/hello' の 'Description:' フィールドが正しく設定されているかどうかを確認
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
  
  # テンプレート 'lucie-vmsetup/hello' の 'Description-ja:' フィールドが正しく設定されているかどうかを確認
  public
  def test_template_hello_description_ja
    assert_equal (<<-DESCRIPTION_JA), Lucie::Template.lookup( 'lucie-vmsetup/hello' ).description_ja
こんにちは
Lucie VM のセットアップウィザードへようこそ
    DESCRIPTION_JA
    assert_equal (<<-DESCRIPTION_JA), Lucie::Template.lookup( 'lucie-vmsetup/hello' )['Description-ja']
こんにちは
Lucie VM のセットアップウィザードへようこそ
    DESCRIPTION_JA
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
    assert_equal Template::STRING, Lucie::Template.lookup( 'lucie-vmsetup/num-nodes' ).template_type
    assert_equal Template::STRING, Lucie::Template.lookup( 'lucie-vmsetup/num-nodes' )['Type']
  end
  
  # テンプレート 'lucie-vmsetup/num-nodes' の 'Description-ja:' フィールドが正しく設定されているかどうかを確認
  public
  def test_template_hello_description_ja
    assert_equal (<<-DESCRIPTION_JA), Lucie::Template.lookup( 'lucie-vmsetup/num-nodes' ).description_ja
VM ノード台数の選択です
使用したい VM の台数を入れてください
    DESCRIPTION_JA
    assert_equal (<<-DESCRIPTION_JA), Lucie::Template.lookup( 'lucie-vmsetup/num-nodes' )['Description-ja']
VM ノード台数の選択です
使用したい VM の台数を入れてください
    DESCRIPTION_JA
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
    assert_equal Template::BOOLEAN, Lucie::Template.lookup( 'lucie-vmsetup/use-network' ).template_type
    assert_equal Template::BOOLEAN, Lucie::Template.lookup( 'lucie-vmsetup/use-network' )['Type']
  end
  
  # テンプレート 'lucie-vmsetup/use-network' の 'Default:' フィールドが正しく設定されているかどうかを確認
  public
  def test_template_use_network_default
    assert_equal 'no', Lucie::Template.lookup( 'lucie-vmsetup/use-network' ).default
    assert_equal 'no', Lucie::Template.lookup( 'lucie-vmsetup/use-network' )['Default']
  end
  
  # テンプレート 'lucie-vmsetup/use-network' の 'Description-ja:' フィールドが正しく設定されているかどうかを確認
  public
  def test_template_use_network_description_ja
    assert_equal (<<-DESCRIPTION_JA), Lucie::Template.lookup( 'lucie-vmsetup/use-network' ).description_ja
ノードのネットワーク
ノードはネットワークにつながりますか？
    DESCRIPTION_JA
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
    assert_equal Template::STRING, Lucie::Template.lookup( 'lucie-vmsetup/ip' ).template_type
    assert_equal Template::STRING, Lucie::Template.lookup( 'lucie-vmsetup/ip' )['Type']
  end
  
  # テンプレート 'lucie-vmsetup/ip' の 'Description-ja:' フィールドが正しく設定されているかどうかを確認
  def test_template_ip_description_ja
    assert_equal (<<-DESCRIPTION_JA), Lucie::Template.lookup( 'lucie-vmsetup/ip' ).description_ja
ノードの ip アドレス
ノードの IP アドレスは？
    DESCRIPTION_JA
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
    assert_equal Template::STRING, Lucie::Template.lookup( 'lucie-vmsetup/memory-size' ).template_type
    assert_equal Template::STRING, Lucie::Template.lookup( 'lucie-vmsetup/memory-size' )['Type']
  end
  
  # テンプレート 'lucie-vmsetup/memory-size' の 'Description-ja:' フィールドが正しく設定されているかどうかを確認
  public
  def test_template_memory_size_description_ja
    assert_equal (<<-DESCRIPTION_JA), Lucie::Template.lookup( 'lucie-vmsetup/memory-size' ).description_ja
ノードのメモリ
使用したいメモリ容量を入力してください (単位: MB)
    DESCRIPTION_JA
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
