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
  # デフォルトで登録されている required attributes を確認
  # 最初に実行しないとデフォルトが以降のテストで消されてしまうので、test00 としておく。
  public
  def test00_default_required_attributes
    assert_equal( [:name, :version, :section, :maintainer, :architecture, :depends, :short_description, :extended_description, :changelog, :priority, :readme],
                  LMP::Specification.required_attributes, 'required attributes が正しくない' )
  end

  # デフォルトで登録されている attributes を確認
  # 最初に実行しないとデフォルトが以降のテストで消されてしまうので、test00 としておく。  
  public
  def test00_default_attributes
    assert_equal( [:name, :version, :section, :maintainer, :architecture, :depends, :short_description, :extended_description, :changelog, :priority, :readme, :copyright],
                  LMP::Specification.attribute_names, 'attributes が正しくない' )
  end
  
  # required attribute を登録し、登録されていることを確認
  public
  def test_required_attributes
    clear_all_attributes
    assert_equal( [], LMP::Specification.required_attributes, 'required attributes が clear できない' )
    LMP::Specification.required_attribute( :test_attribute_no1, 'DEFAULT VALUE NO1' )
    LMP::Specification.required_attribute( :test_attribute_no2, 'DEFAULT VALUE NO2' )
    assert_equal( [:test_attribute_no1, :test_attribute_no2], LMP::Specification.required_attribute_names )
    
    spec = LMP::Specification.new
    assert_equal( 'DEFAULT VALUE NO1', spec.test_attribute_no1, 'required attribute のデフォルト値がセットされていない' )
    assert_equal( 'DEFAULT VALUE NO2', spec.test_attribute_no2, 'required attribute のデフォルト値がセットされていない' )
  end
  
  # attribute を登録し、登録されていることを確認
  public
  def test_attribute
    clear_all_attributes
    assert_equal( [], LMP::Specification.attribute_names, 'attributes が clear できない' )
    LMP::Specification.attribute( :test_attribute_no1, 'DEFAULT VALUE NO1' )
    LMP::Specification.attribute( :test_attribute_no2, 'DEFAULT VALUE NO2' )
    assert_equal( [:test_attribute_no1, :test_attribute_no2], LMP::Specification.attribute_names )
    
    spec = LMP::Specification.new
    assert_equal( 'DEFAULT VALUE NO1', spec.test_attribute_no1, 'required attribute のデフォルト値がセットされていない' )
    assert_equal( 'DEFAULT VALUE NO2', spec.test_attribute_no2, 'required attribute のデフォルト値がセットされていない' )
  end
  
  # あらかじめ登録されている (required) attribute を消去しておく
  private
  def clear_all_attributes
    LMP::Specification.attributes_clear
    LMP::Specification.required_attributes_clear    
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: