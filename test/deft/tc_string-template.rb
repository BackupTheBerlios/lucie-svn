#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$KCODE = 'SJIS'
$LOAD_PATH.unshift './lib'

require 'deft/string-template'
require 'test/unit'

class TC_StringTemplate < Test::Unit::TestCase
  # 親クラスが Deft::Template であることをテスト
  public
  def test_inheritance
    assert Deft::StringTemplate < Deft::Template
  end
  
  public
  def test_to_s
    Deft::Template.clear
    template( 'TEST/STRING-TEMPLATE' ) do |template|
      template.template_type = Deft::StringTemplate
      template.default = 'default'
      template.short_description = 'This is a short description'
      template.extended_description = (<<-DESCRIPTION)
      This is a long description
      
      the abobe is a null line
      DESCRIPTION
      template.short_description_ja = 'これは短いデスクリプションです'
      template.extended_description_ja = (<<-DESCRIPTION_JA)      
      これは長いデスクリプションです
      
      上は空行です
      DESCRIPTION_JA
    end
    assert /^Template:(.*)^Type:(.*)^Default:(.*)^Description:(.*)^Description-ja:(.*)/m=~ Deft::Template['TEST/STRING-TEMPLATE'].to_s
    assert_match /TEST\/STRING-TEMPLATE/, $1, 'Template: の値がおかしい'
    assert_match /string/, $2, 'Type: の値がおかしい'
    assert_match /default/, $3, 'Default: の値がおかしい'
    assert_match /This is a short description.*This is a long description.*the abobe is a null line/m, $4, 'Description: の値がおかしい'
    assert_match /これは短いデスクリプションです.*これは長いデスクリプションです.*上は空行です/m, $5, 'Description-ja: の値がおかしい'
  end
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
