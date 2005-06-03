#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'lmp/template'
require 'test/unit'

# ���������ƥ�ץ졼�Ȥ����ƤˤĤ��ƤϹͤ������ƥ�ץ졼�������᥽��
# �ɤ����뤫�ɤ����Τߤ�ƥ���
class TC_Template < Test::Unit::TestCase
  public
  def test_respond_to_changelog
    assert( LMP::Template.respond_to?( :config ), "Template#changelog �᥽�åɤ�̵��" )
  end

  public
  def test_respond_to_config
    assert( LMP::Template.respond_to?( :config ), "Template#config �᥽�åɤ�̵��" )
  end

  public
  def test_respond_to_control
    assert( LMP::Template.respond_to?( :control ), "Template#control �᥽�åɤ�̵��" )
  end

  public
  def test_respond_to_package
    assert( LMP::Template.respond_to?( :package ), "Template#package �᥽�åɤ�̵��" )
  end

  public
  def test_respond_to_readme
    assert( LMP::Template.respond_to?( :readme ), "Template#readme �᥽�åɤ�̵��" )
  end

  public
  def test_respond_to_rules
    assert( LMP::Template.respond_to?( :rules ), "Template#rules �᥽�åɤ�̵��" )
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
