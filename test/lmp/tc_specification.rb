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
  # �f�t�H���g�œo�^����Ă��� required attributes ���m�F
  # �ŏ��Ɏ��s���Ȃ��ƃf�t�H���g���ȍ~�̃e�X�g�ŏ�����Ă��܂��̂ŁAtest00 �Ƃ��Ă����B
  public
  def test00_default_required_attributes
    assert_equal( [:name, :version, :section, :maintainer, :architecture, :depends, :short_description, :extended_description, :changelog, :priority, :readme],
                  LMP::Specification.required_attributes, 'required attributes ���������Ȃ�' )
  end

  # �f�t�H���g�œo�^����Ă��� attributes ���m�F
  # �ŏ��Ɏ��s���Ȃ��ƃf�t�H���g���ȍ~�̃e�X�g�ŏ�����Ă��܂��̂ŁAtest00 �Ƃ��Ă����B  
  public
  def test00_default_attributes
    assert_equal( [:name, :version, :section, :maintainer, :architecture, :depends, :short_description, :extended_description, :changelog, :priority, :readme, :copyright],
                  LMP::Specification.attribute_names, 'attributes ���������Ȃ�' )
  end
  
  # required attribute ��o�^���A�o�^����Ă��邱�Ƃ��m�F
  public
  def test_required_attributes
    clear_all_attributes
    assert_equal( [], LMP::Specification.required_attributes, 'required attributes �� clear �ł��Ȃ�' )
    LMP::Specification.required_attribute( :test_attribute_no1, 'DEFAULT VALUE NO1' )
    LMP::Specification.required_attribute( :test_attribute_no2, 'DEFAULT VALUE NO2' )
    assert_equal( [:test_attribute_no1, :test_attribute_no2], LMP::Specification.required_attribute_names )
    
    spec = LMP::Specification.new
    assert_equal( 'DEFAULT VALUE NO1', spec.test_attribute_no1, 'required attribute �̃f�t�H���g�l���Z�b�g����Ă��Ȃ�' )
    assert_equal( 'DEFAULT VALUE NO2', spec.test_attribute_no2, 'required attribute �̃f�t�H���g�l���Z�b�g����Ă��Ȃ�' )
  end
  
  # attribute ��o�^���A�o�^����Ă��邱�Ƃ��m�F
  public
  def test_attribute
    clear_all_attributes
    assert_equal( [], LMP::Specification.attribute_names, 'attributes �� clear �ł��Ȃ�' )
    LMP::Specification.attribute( :test_attribute_no1, 'DEFAULT VALUE NO1' )
    LMP::Specification.attribute( :test_attribute_no2, 'DEFAULT VALUE NO2' )
    assert_equal( [:test_attribute_no1, :test_attribute_no2], LMP::Specification.attribute_names )
    
    spec = LMP::Specification.new
    assert_equal( 'DEFAULT VALUE NO1', spec.test_attribute_no1, 'required attribute �̃f�t�H���g�l���Z�b�g����Ă��Ȃ�' )
    assert_equal( 'DEFAULT VALUE NO2', spec.test_attribute_no2, 'required attribute �̃f�t�H���g�l���Z�b�g����Ă��Ȃ�' )
  end
  
  # ���炩���ߓo�^����Ă��� (required) attribute ���������Ă���
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