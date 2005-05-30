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
  
  # @name の getter をテスト
  public
  def test_name_getter
    assert_equal 'TEST ABSTRACT TEMPLATE', @abstract_template.name
  end
  
  # inspect の返り値をテスト
  public
  def test_inspect
    assert_equal( %{#<Deft::AbstractTemplate: @name="TEST ABSTRACT TEMPLATE">},
                  @abstract_template.inspect )
  end
  
  # to_s で NotImplementedError が raise されることを確認
  public
  def test_to_s_raises_not_implemented_error
    assert_raises( NotImplementedError, "NotImplementedError が to_s で raise されなかった" ) do
      @abstract_template.to_s
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: