#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$KCODE = 'SJIS'
$LOAD_PATH.unshift './lib'

require 'deft/note-template'
require 'test/unit'

class TC_NoteTemplate < Test::Unit::TestCase
  # 親クラスが Deft::Template であることをテスト
  public
  def test_inheritance
    assert Deft::NoteTemplate < Deft::Template
  end
  
  public
  def test_to_s
    Deft::Template.clear
    template( 'TEST/NOTE-TEMPLATE' ) do |template|
      template.template_type = Deft::NoteTemplate
      template.default = 'no'
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
    assert /^Template:(.*)^Type:(.*)^Description:(.*)^Description-ja:(.*)/m=~ Deft::Template['TEST/NOTE-TEMPLATE'].to_s
    assert_match /TEST\/NOTE-TEMPLATE/, $1, 'Template: の値がおかしい'
    assert_match /note/, $2, 'Type: の値がおかしい'
    assert_match /This is a short description.*This is a long description.*the abobe is a null line/m, $3, 'Description: の値がおかしい'
    assert_match /これは短いデスクリプションです.*これは長いデスクリプションです.*上は空行です/m, $4, 'Description-ja: の値がおかしい'
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: