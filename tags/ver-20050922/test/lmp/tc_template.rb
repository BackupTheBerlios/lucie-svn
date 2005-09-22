#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'lmp/template'
require 'test/unit'

# 生成されるテンプレートの内容については考えず、テンプレート生成メソッ
# ドがあるかどうかのみをテスト
class TC_Template < Test::Unit::TestCase
  public
  def test_respond_to_changelog
    assert( LMP::Template.respond_to?( :config ), "Template#changelog メソッドが無い" )
  end

  public
  def test_respond_to_config
    assert( LMP::Template.respond_to?( :config ), "Template#config メソッドが無い" )
  end

  public
  def test_respond_to_control
    assert( LMP::Template.respond_to?( :control ), "Template#control メソッドが無い" )
  end

  public
  def test_respond_to_package
    assert( LMP::Template.respond_to?( :package ), "Template#package メソッドが無い" )
  end

  public
  def test_respond_to_readme
    assert( LMP::Template.respond_to?( :readme ), "Template#readme メソッドが無い" )
  end

  public
  def test_respond_to_rules
    assert( LMP::Template.respond_to?( :rules ), "Template#rules メソッドが無い" )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
