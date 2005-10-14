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

  # ------------------------- °���Υƥ���.

  public
  def test_section_default_value
    assert_equal( 'misc', @specification.section, 
                  "Specification#section �Υǥե�����ͤ��������ʤ�" )
  end

  public
  def test_architecture_default_value
    assert_equal( 'all', @specification.architecture, 
                  "Specification#architecture �Υǥե�����ͤ��������ʤ�" )
  end

  public
  def test_priority_default_value
    assert_equal( 'optional', @specification.priority, 
                  "Specification#priority �Υǥե�����ͤ��������ʤ�" )
  end

  public
  def test_package_default_value
    assert_kind_of( String, @specification.package, 
                    "Specification#package �Υǥե�����ͤ��������ʤ�" )
  end

  public
  def test_files_default_value
    assert_equal( ['debian/README.Debian', 'debian/changelog',
                    'debian/config', 'debian/control',
                    'debian/copyright', 'debian/postinst',
                    'debian/rules', 'debian/templates', 'package'],
                  @specification.files,  "Specification#files �Υǥե�����ͤ��������ʤ�" )
  end

  # ��°�����ͤ򥻥åȤǤ��뤳�Ȥ�ƥ���
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
      fail "#{attributeNameString} °�����ͤ򥻥åȤ���Ȥ��˥��顼��ȯ��"
    end
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

  # ���٤ƤΥƥ�ץ졼�������᥽�åɤ� read only �Ǥ��뤳�Ȥ�ƥ���

  public
  def test_config_read_only
    assert_raises( NoMethodError, "Specification#config �� Read Only �Ǥʤ�" ) do 
      @specification.config = nil
    end
  end

  public
  def test_control_read_only
    assert_raises( NoMethodError, "Specification#control �� Read Only �Ǥʤ�" ) do 
      @specification.control = nil
    end
  end

  public
  def test_rules_read_only
    assert_raises( NoMethodError, "Specification#rules �� Read Only �Ǥʤ�" ) do 
      @specification.rules = nil
    end
  end

  public
  def test_readme_read_only
    assert_raises( NoMethodError, "Specification#readme �� Read Only �Ǥʤ�" ) do 
      @specification.readme = nil
    end
  end

  public
  def test_changelog_read_only
    assert_raises( NoMethodError, "Specification#changelog �� Read Only �Ǥʤ�" ) do 
      @specification.changelog = nil
    end
  end

  public
  def test_templates_read_only
    assert_raises( NoMethodError, "Specification#templates �� Read Only �Ǥʤ�" ) do 
      @specification.templates = nil
    end
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
