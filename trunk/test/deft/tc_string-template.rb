#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'deft/string-template'
require 'test/unit'

class TC_StringTemplate < Test::Unit::TestCase
  public
  def setup
    Deft::Template.clear
  end
  
  public
  def teardown
    Deft::Template.clear
  end
  
  public
  def test_register
    template = template( 'TEST/STRING-TEMPLATE' ) do |template|
      template.template_type = 'string'
      template.default = 'default'
      template.short_description = 'This is a short description'
      template.extended_description = 'This is a extended description'
      template.short_description_ja = 'これは短いデスクリプションです'
      template.extended_description_ja = 'これは長いデスクリプションです'
    end
    assert_equal( 'TEST/STRING-TEMPLATE', template.name,
                  'name アトリビュートの値が正しくない' )
    assert_equal( 'string', template.template_type,
                  'template_type アトリビュートの値が正しくない' )
    assert_equal( 'default', template.default,
                  'default アトリビュートの値が正しくない' )
    assert_equal( 'This is a short description', template.short_description,
                  'short_description アトリビュートの値が正しくない' )
    assert_equal( 'This is a extended description', template.extended_description,
                  'extended_description アトリビュートの値が正しくない' ) 
    assert_equal( 'これは短いデスクリプションです', template.short_description_ja,
                  'short_description_ja アトリビュートの値が正しくない' ) 
    assert_equal( 'これは長いデスクリプションです', template.extended_description_ja,
                  'extended_description_ja アトリビュートの値が正しくない' )
  end
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
