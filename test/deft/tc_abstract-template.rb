#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'mock'
require 'deft/abstract-template'
require 'test/unit'

class TC_AbstractTemplate < Test::Unit::TestCase
  public
  def setup
    @template = Mock.new( '[TEMPLATE]' )
    @abstract_template = Deft::AbstractTemplate.new( @template )
  end
  
  public
  def test_name
    @template.__next( :name ) do 'NAME' end
    assert_equal( 'NAME', @abstract_template.name, 
                  'name フィールドが正しくない' )
    @template.__verify
  end
  
  public
  def test_template_type
    @template.__next( :template_type ) do 'TEMPLATE TYPE' end
    assert_equal( 'TEMPLATE TYPE', @abstract_template.template_type, 
                  'template_type フィールドが正しくない' )
    @template.__verify
  end
  
  public
  def test_default
    @template.__next( :default ) do 'DEFAULT' end
    assert_equal( 'DEFAULT', @abstract_template.default, 
                  'default フィールドが正しくない' )
    @template.__verify
  end
  
  public
  def test_choices
    @template.__next( :choices ) do ['CHOICE 1', 'CHOICE 2', 'CHOICE 3'] end
    assert_equal( ['CHOICE 1', 'CHOICE 2', 'CHOICE 3'], @abstract_template.choices, 
                  'choices フィールドが正しくない' )
    @template.__verify
  end
  
  public
  def test_short_description
    @template.__next( :short_description ) do 'SHORT DESCRIPTION' end
    assert_equal( 'SHORT DESCRIPTION', @abstract_template.short_description, 
                  'short_description フィールドが正しくない' )
    @template.__verify
  end
  
  public
  def test_extended_description
    @template.__next( :extended_description ) do 'EXTENDED DESCRIPTION' end
    assert_equal( 'EXTENDED DESCRIPTION', @abstract_template.extended_description, 
                  'extended_description フィールドが正しくない' )
    @template.__verify
  end
  
  public
  def test_short_description_ja
    @template.__next( :short_description_ja ) do 'SHORT DESCRIPTION JA' end
    assert_equal( 'SHORT DESCRIPTION JA', @abstract_template.short_description_ja, 
                  'short_description_ja フィールドが正しくない' )
    @template.__verify
  end
  
  public
  def test_extended_description_ja
    @template.__next( :extended_description_ja ) do 'EXTENDED DESCRIPTION JA' end
    assert_equal( 'EXTENDED DESCRIPTION JA', @abstract_template.extended_description_ja,
                  'extended_description_ja フィールドが正しくない' )
    @template.__verify
  end
  
  public
  def test_to_s
    assert_raises( NotImplementedError, 'NotImplementedError が raise されなかった' ) do
      @abstract_template.to_s
    end
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
