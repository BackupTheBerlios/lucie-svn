#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$KCODE = 'SJIS'
$LOAD_PATH.unshift './lib'

require 'lucie/string-template'
require 'test/unit'

class TC_StringTemplate < Test::Unit::TestCase
  # 親クラスが Lucie::Template であることをテスト
  public
  def test_inheritance
    assert Lucie::StringTemplate < Lucie::Template
  end
  
  public
  def test_to_s
    Lucie::Template.clear
    template( 'TEST/STRING-TEMPLATE', Lucie::StringTemplate ) do |template|
      template.default = 'no'
      template.description = (<<-DESCRIPTION)
      This is a short description
      This is a long description
      
      the abobe is a null line
      DESCRIPTION
      template.description_ja = (<<-DESCRIPTION_JA)
      これは短いデスクリプションです
      これは長いデスクリプションです
      
      上は空行です
      DESCRIPTION_JA
    end
    
    assert /^Template:(.*)^Type:(.*)^Description:(.*)^Description-ja:(.*)/m=~ Lucie::Template['TEST/STRING-TEMPLATE'].to_s
    assert_match /TEST\/STRING-TEMPLATE/, $1, 'Template: の値がおかしい'
    assert_match /string/, $2, 'Type: の値がおかしい'
    assert_match /This is a short description.*This is a long description.*the abobe is a null line/m, $3, 'Description: の値がおかしい'
    assert_match /これは短いデスクリプションです.*これは長いデスクリプションです.*上は空行です/m, $4, 'Description-ja: の値がおかしい'
  end
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
