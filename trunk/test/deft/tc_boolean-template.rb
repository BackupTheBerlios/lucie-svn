#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'deft/boolean-template'
require 'test/unit'

class TC_BooleanTemplate < Test::Unit::TestCase
  public
  def setup
    @boolean_template = Deft::BooleanTemplate.new( 'TEST BOOLEAN TEMPLATE' )
  end

  # to_s �� Deft::Exception::RequiredAttributeException �� raise ����뤳�Ȥ�ƥ���
  # short/extended description ��·�äƤ��ʤ����ˤϾ嵭�㳰�� raise ����롣
  public
  def test_to_s_raises_required_attribute_exception
    assert_raises( Deft::Exception::RequiredAttributeException,
                   "Deft::Exception::RequiredAttributeException �� raise ����ʤ��ä�" ) do
      @boolean_template.to_s
    end

    # extended ��̵���Τ��㳰ȯ��
    @boolean_template.short_description = 'TEST SHORT DESCRIPTION'
    @boolean_template.extended_description = nil
    @boolean_template.short_description_ja = nil
    @boolean_template.extended_description_ja = nil
    assert_raises( Deft::Exception::RequiredAttributeException,
                   "Deft::Exception::RequiredAttributeException �� raise ����ʤ��ä�" ) do
      @boolean_template.to_s
    end

    # short/extended ��·�äƤ���Τ��㳰��ȯ�����ʤ�
    @boolean_template.short_description = 'TEST SHORT DESCRIPTION'
    @boolean_template.extended_description = 'TEST EXTENDED DESCRIPTION'
    @boolean_template.short_description_ja = nil
    @boolean_template.extended_description_ja = nil
    begin
      @boolean_template.to_s
    rescue
      fail "to_s ��ͽ�����ʤ��㳰�� raise ���줿"
    end

    # extended..._ja ��̵���Τ��㳰ȯ��
    @boolean_template.short_description = nil
    @boolean_template.extended_description = nil
    @boolean_template.short_description_ja = 'TEST SHORT DESCRIPTION JA'
    @boolean_template.extended_description_ja = nil
    assert_raises( Deft::Exception::RequiredAttributeException,
                   "Deft::Exception::RequiredAttributeException �� raise ����ʤ��ä�" ) do
      @boolean_template.to_s
    end

    # short..._ja/extended..._ja ��·�äƤ���Τ��㳰��ȯ�����ʤ�
    @boolean_template.short_description = nil
    @boolean_template.extended_description = nil
    @boolean_template.short_description_ja = 'TEST SHORT DESCRIPTION JA'
    @boolean_template.extended_description_ja = 'TEST EXTENDED DESCRIPTION JA'
    begin
      @boolean_template.to_s
    rescue
      fail "to_s ��ͽ�����ʤ��㳰�� raise ���줿"
    end
  end
  
  # to_s �� templates ʸ������������������뤳�Ȥ�ƥ���
  #--
  # TODO: default= �ΰ��������å� (yes/no ���������դ���)
  #++ 
  public
  def test_to_s
    @boolean_template.default = 'yes'
    @boolean_template.short_description = 'TEST SHORT DESCRIPTION'
    @boolean_template.extended_description = 'TEST EXTENDED DESCRIPTION'
    @boolean_template.short_description_ja = 'TEST SHORT DESCRIPTION JA'
    @boolean_template.extended_description_ja = 'TEST EXTENDED DESCRIPTION JA'
    assert_equal( (<<-BOOLEAN_TEMPLATE).chomp, @boolean_template.to_s, "to_s ���������ͤ��֤��ʤ�" )
Template: TEST BOOLEAN TEMPLATE
Type: boolean
Default: yes
Description: TEST SHORT DESCRIPTION
 TEST EXTENDED DESCRIPTION
Description-ja: TEST SHORT DESCRIPTION JA
 TEST EXTENDED DESCRIPTION JA
   BOOLEAN_TEMPLATE
  end

  # @choices= �� Deft::Exception::InvalidAttributeException ���֤����Ȥ�ƥ���
  public 
  def test_setter_choices_raises_invalid_attribute_exception
    assert_raises( Deft::Exception::InvalidAttributeException, 
                   '@choices �ؤ������� InvalidAttributeException �� raise ����ʤ��ä�' ) do 
      @boolean_template.choices = 'THIS MUST RAISE EXCEPTION'
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
