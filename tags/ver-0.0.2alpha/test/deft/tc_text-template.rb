#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$KCODE = 'SJIS'
$LOAD_PATH.unshift './lib'

require 'deft/text-template'
require 'test/unit'

class TC_TextTemplate < Test::Unit::TestCase
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
    template = template( 'TEST/TEXT-TEMPLATE' ) do |template|
      template.template_type = 'text'
      template.short_description = 'This is a short description'
      template.extended_description = 'This is a extended description'      
      template.short_description_ja = 'これは短いデスクリプションです'
      template.extended_description_ja = 'これは長いデスクリプションです'
    end    
    assert_equal( 'TEST/TEXT-TEMPLATE', template.name,
                  'name アトリビュートの値が正しくない' )
    assert_equal( 'text', template.template_type,
                  'template_type アトリビュートの値が正しくない' )
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