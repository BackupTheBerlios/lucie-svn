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

  # ------------------------- Template �᥽�åɤΥƥ���.

  # ���������ƥ�ץ졼�Ȥ����ƤˤĤ��ƤϹͤ������ƥ�ץ졼�������᥽��
  # �ɤ����뤫�ɤ����Τߤ�ƥ���

  public
  def test_respond_to_config
    assert( @specification.respond_to?( :config ),
            "Specificatoin#config �᥽�åɤ�̵��" )
  end

  public
  def test_respond_to_control
    assert( @specification.respond_to?( :control ),
            "Specificatoin#control �᥽�åɤ�̵��" )
  end

  public
  def test_respond_to_rules
    assert( @specification.respond_to?( :rules ),
            "Specificatoin#rules �᥽�åɤ�̵��" )
  end

  public
  def test_respond_to_readme
    assert( @specification.respond_to?( :readme ),
            "Specificatoin#readme �᥽�åɤ�̵��" )
  end

  public
  def test_respond_to_changelog
    assert( @specification.respond_to?( :changelog ),
            "Specificatoin#changelog �᥽�åɤ�̵��" )
  end

  public
  def test_respond_to_templates
    assert( @specification.respond_to?( :templates ),
            "Specificatoin#templates �᥽�åɤ�̵��" )
  end

  # ------------------------- Debug �᥽�åɤΥƥ���.

  public
  def test_to_s
    assert_equal( %{#<LMP::Specification name= version=>}, @specification.to_s,
                  "Specification#to_s ���֤��ͤ��������ʤ�" )
  end

  public
  def test_inspect
    assert_equal( %{#<LMP::Specification name= version=>}, @specification.inspect,
                  "Specification#inspect ���֤��ͤ��������ʤ�" )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
