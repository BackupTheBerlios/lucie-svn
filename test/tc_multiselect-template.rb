#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$KCODE = 'SJIS'
$LOAD_PATH.unshift './lib'

require 'lucie/multiselect-template'
require 'test/unit'

class TC_MultiselectTemplate < Test::Unit::TestCase
  # 親クラスが Lucie::Template であることをテスト
  public
  def test_inheritance
    assert Lucie::MultiselectTemplate < Lucie::Template
  end
  
  public
  def test_to_s
    Lucie::Template.clear
    template( 'TEST/MULTISELECT-TEMPLATE', Lucie::MultiselectTemplate ) do |template|
      template.choices = ['CHOICE #1', 'CHOICE #1', 'CHOICE #3']
      template.default = 'CHOICE #1'
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
    
    assert /^Template:(.*)^Type:(.*)^Choices:(.*)^Default:(.*)^Description:(.*)^Description-ja:(.*)/m=~ Lucie::Template['TEST/MULTISELECT-TEMPLATE'].to_s
    assert_match /TEST\/MULTISELECT-TEMPLATE/, $1, 'Template: の値がおかしい'
    assert_match /multiselect/, $2, 'Type: の値がおかしい'
    assert_match /CHOICE #1, CHOICE #1, CHOICE #3/, $3, 'Choices: の値がおかしい'
    assert_match /CHOICE #1/, $4, 'Default: の値がおかしい'
    assert_match /This is a short description.*This is a long description.*the abobe is a null line/m, $5, 'Description: の値がおかしい'
    assert_match /これは短いデスクリプションです.*これは長いデスクリプションです.*上は空行です/m, $6, 'Description-ja: の値がおかしい'
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
