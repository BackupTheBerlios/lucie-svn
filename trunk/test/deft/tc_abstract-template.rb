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
  
  # @name �� getter ��ƥ���
  public
  def test_name_getter
    assert_equal 'TEST ABSTRACT TEMPLATE', @abstract_template.name
  end
  
  # inspect ���֤��ͤ�ƥ���
  public
  def test_inspect
    assert_equal( %{#<Deft::AbstractTemplate: @name="TEST ABSTRACT TEMPLATE">},
                  @abstract_template.inspect )
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