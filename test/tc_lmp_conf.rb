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
  
  # タスク 'lucie-vmsetup/hello' が登録されていることを確認
  public
  def test_template_hello_registered
    assert Lucie::Template.template_defined?( 'lucie-vmsetup/hello' )
  end
  
  # タスク 'lucie-vmsetup/hello' の 'Type:' フィールドが正しく設定されているかどうかを確認
  public
  def test_template_hello_type
    assert_equal Template::NOTE, Lucie::Template.lookup( 'lucie-vmsetup/hello' ).template_type
    assert_equal Template::NOTE, Lucie::Template.lookup( 'lucie-vmsetup/hello' )['Type']
  end
  
  # タスク 'lucie-vmsetup/hello' の 'Description:' フィールドが正しく設定されているかどうかを確認
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
  
  # タスク 'lucie-vmsetup/hello' の 'Description-ja:' フィールドが正しく設定されているかどうかを確認
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
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
