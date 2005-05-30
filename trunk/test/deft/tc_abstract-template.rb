#
# $Id: tc_boolean-template.rb 520 2005-04-05 05:15:36Z takamiya $
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision: 520 $
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
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: