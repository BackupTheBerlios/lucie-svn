#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift 'trunk/lib'

require 'lmp/specification'
require 'test/unit'

class TC_Specification < Test::Unit::TestCase
  public
  def setup
    @specification = LMP::Specification.new
  end

  # ------------------------- 属性のテスト.

  public
  def test_section_default_value
    assert_equal( 'misc', @specification.section, 
                  "Specification#section のデフォルト値が正しくない" )
  end

  public
  def test_architecture_default_value
    assert_equal( 'all', @specification.architecture, 
                  "Specification#architecture のデフォルト値が正しくない" )
  end

  public
  def test_priority_default_value
    assert_equal( 'optional', @specification.priority, 
                  "Specification#priority のデフォルト値が正しくない" )
  end

  public
  def test_package_default_value
    assert_kind_of( String, @specification.package, 
                    "Specification#package のデフォルト値が正しくない" )
  end

  public
  def test_files_default_value
    assert_equal( ['debian/README.Debian', 'debian/changelog',
                    'debian/config', 'debian/control',
                    'debian/copyright', 'debian/postinst',
                    'debian/rules', 'debian/templates', 'package'],
                  @specification.files,  "Specification#files のデフォルト値が正しくない" )
  end

  # 各属性に値をセットできることをテスト
  public
  def test_setter_methods
    [:name, :version, :section, :maintainer, :architecture,
      :short_description, :extended_description, :changelog,
      :priority, :readme, :control, :postinst, :rules, :deft,
      :templates, :package, :config, :copyright, :files].each do |each|
      setter_method_test each
    end
  end

  private
  def setter_method_test( attributeNameSymbol )
    begin
      LMP::Specification.new do |spec|
        spec.send( attributeNameSymbol.to_s + '=', nil )
      end
    rescue
      fail "#{attributeNameString} 属性に値をセットするときにエラーが発生"
    end
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

  # すべてのテンプレート生成メソッドが read only であることをテスト

  public
  def test_config_read_only
    assert_raises( NoMethodError, "Specification#config が Read Only でない" ) do 
      @specification.config = nil
    end
  end

  public
  def test_control_read_only
    assert_raises( NoMethodError, "Specification#control が Read Only でない" ) do 
      @specification.control = nil
    end
  end

  public
  def test_rules_read_only
    assert_raises( NoMethodError, "Specification#rules が Read Only でない" ) do 
      @specification.rules = nil
    end
  end

  public
  def test_readme_read_only
    assert_raises( NoMethodError, "Specification#readme が Read Only でない" ) do 
      @specification.readme = nil
    end
  end

  public
  def test_changelog_read_only
    assert_raises( NoMethodError, "Specification#changelog が Read Only でない" ) do 
      @specification.changelog = nil
    end
  end

  public
  def test_templates_read_only
    assert_raises( NoMethodError, "Specification#templates が Read Only でない" ) do 
      @specification.templates = nil
    end
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
