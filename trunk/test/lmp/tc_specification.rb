#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'lmp/specification'
require 'test/unit'

class TC_Specification < Test::Unit::TestCase
  public
  def setup
    @specification = LMP::Specification.new
  end

  # ------------------------- Template メソッドのテスト.

  # 生成されるテンプレートの内容については考えず、テンプレート生成メソッ
  # ドがあるかどうかのみをテスト

  public
  def test_respond_to_config
    assert( @specification.respond_to?( :config ),
            "Specificatoin#config メソッドが無い" )
  end

  public
  def test_respond_to_control
    assert( @specification.respond_to?( :control ),
            "Specificatoin#control メソッドが無い" )
  end

  public
  def test_respond_to_rules
    assert( @specification.respond_to?( :rules ),
            "Specificatoin#rules メソッドが無い" )
  end

  public
  def test_respond_to_readme
    assert( @specification.respond_to?( :readme ),
            "Specificatoin#readme メソッドが無い" )
  end

  public
  def test_respond_to_changelog
    assert( @specification.respond_to?( :changelog ),
            "Specificatoin#changelog メソッドが無い" )
  end

  public
  def test_respond_to_templates
    assert( @specification.respond_to?( :templates ),
            "Specificatoin#templates メソッドが無い" )
  end

  # ------------------------- Debug メソッドのテスト.

  public
  def test_to_s
    assert_equal( %{#<LMP::Specification name= version=>}, @specification.to_s,
                  "Specification#to_s の返り値が正しくない" )
  end

  public
  def test_inspect
    assert_equal( %{#<LMP::Specification name= version=>}, @specification.inspect,
                  "Specification#inspect の返り値が正しくない" )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
