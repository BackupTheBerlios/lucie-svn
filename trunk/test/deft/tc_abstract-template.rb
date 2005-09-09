#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'deft/text-template'
require 'deft/abstract-template'
require 'test/unit'

class TC_AbstractTemplate < Test::Unit::TestCase
  public
  def setup
    @abstract_template = Deft::AbstractTemplate.new( 'TEST ABSTRACT TEMPLATE' )
  end

  public
  def test_to_s
    assert_raises( Deft::Exception::RequiredAttributeException) do
      @abstract_template.to_s
    end
  end

  public
  def test_template_type
    text_template = Deft::TextTemplate.new( 'text template' )
    assert_equal( 'text', text_template.template_type )

    select_template = Deft::SelectTemplate.new( 'select template' )
    assert_equal( 'select', select_template.template_type )

    note_template = Deft::NoteTemplate.new( 'note template' )
    assert_equal( 'note', note_template.template_type )

    boolean_template = Deft::BooleanTemplate.new( 'boolean template' )
    assert_equal( 'boolean', boolean_template.template_type )

    string_template = Deft::StringTemplate.new( 'string template' )
    assert_equal( 'string', string_template.template_type )

    multiselect_template = Deft::MultiselectTemplate.new( 'multiselect template' )
    assert_equal( 'multiselect', multiselect_template.template_type )

    password_template = Deft::PasswordTemplate.new( 'password template' )
    assert_equal( 'password', password_template.template_type )
  end

  # @choices �� accessor ��ƥ���
  public
  def test_choices_accessor 
    assert_nil @abstract_template.choices, "@choices �ν���ͤ� nil �Ǥʤ�"

    @abstract_template.choices = ['CHOICE 1', 'CHOICE 2', 'CHOICE 3']
    assert_equal( ['CHOICE 1', 'CHOICE 2', 'CHOICE 3'],
                  @abstract_template.choices, "@choices �� accessor ��������ư��ʤ�" )

    assert_raises( Deft::Exception::InvalidAttributeException ) do 
      @abstract_template.choices = 'CHOICES'
    end
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
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
