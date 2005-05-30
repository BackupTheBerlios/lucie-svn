#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'deft/abstract-template'
require 'test/unit'

class TC_AbstractTemplate < Test::Unit::TestCase
  public
  def setup
    @abstract_template = Deft::AbstractTemplate.new( 'TEST ABSTRACT TEMPLATE' )
  end

  # @choices �� accessor ��ƥ���
  #--
  # FIXME: @choices �ˤϤɤ�ʥ��֥������Ȥ����뤫�������å��򤳤��Ǥ��뤫��
  #++ 
  public
  def test_choices_accessor 
    @abstract_template.choices = 'CHOICES'
    assert_equal 'CHOICES', @abstract_template.choices, "@choices �� accessor ��������ư��ʤ�"
  end

  # @extended_description_ja �� accessor ��ƥ���
  #--
  # FIXME: @extended_description_ja �η������å� (String) �򤳤��Ǥ��뤫��
  #++ 
  public
  def test_extended_description_ja_accessor
    @abstract_template.extended_description_ja = 'EXTENDED DESCRIPTION JA'
    assert_equal( 'EXTENDED DESCRIPTION JA', @abstract_template.extended_description_ja,
                  "@extended_description_ja �� accessor ��������ư��ʤ�" )
  end

  # @extended_description �� accessor ��ƥ���
  #--
  # FIXME: @extended_description �η������å� (String) �򤳤��Ǥ��뤫��
  #++ 
  public
  def test_extended_description_accessor
    @abstract_template.extended_description = 'EXTENDED DESCRIPTION'
    assert_equal( 'EXTENDED DESCRIPTION', @abstract_template.extended_description,
                  "@extended_description �� accessor ��������ư��ʤ�" )
  end

  # @short_description_ja �� accessor ��ƥ���
  #--
  # FIXME: @short_description_ja �η������å� (String) �򤳤��Ǥ��뤫��
  #++ 
  public
  def test_short_description_ja_accessor
    @abstract_template.short_description_ja = 'SHORT DESCRIPTION JA'
    assert_equal( 'SHORT DESCRIPTION JA', @abstract_template.short_description_ja,
                  "@short_description_ja �� accessor ��������ư��ʤ�" )
  end

  # @short_description �� accessor ��ƥ���
  #--
  # FIXME: @short_description �η������å� (String) �򤳤��Ǥ��뤫��
  #++ 
  public
  def test_short_description_accessor
    @abstract_template.short_description = 'SHORT DESCRIPTION'
    assert_equal( 'SHORT DESCRIPTION', @abstract_template.short_description,
                  "@short_description �� accessor ��������ư��ʤ�" )
  end
  
  # @default �� accessor ��ƥ���
  #--
  # FIXME: @default �ˤϤɤ�ʥ��֥������Ȥ����뤫�������å��򤳤��Ǥ��뤫��
  #++ 
  public
  def test_default_accessor 
    @abstract_template.default = 'DEFAULT'
    assert_equal 'DEFAULT', @abstract_template.default, "@default �� accessor ��������ư��ʤ�"
  end
  
  # @name �� getter ��ƥ���
  public
  def test_name_getter
    assert_equal( 'TEST ABSTRACT TEMPLATE', @abstract_template.name,
                  "@name �� getter ���������ͤ��֤��ʤ�" )
  end
  
  # inspect ���֤��ͤ�ƥ���
  public
  def test_inspect
    assert_equal( %{#<Deft::AbstractTemplate: @name="TEST ABSTRACT TEMPLATE">},
                  @abstract_template.inspect, "inspect ���������ͤ��֤��ʤ�" )
  end
  
  # to_s �� NotImplementedError �� raise ����뤳�Ȥ��ǧ
  public
  def test_to_s_raises_not_implemented_error
    assert_raises( NotImplementedError, "NotImplementedError �� to_s �� raise ����ʤ��ä�" ) do
      @abstract_template.to_s
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
