#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$KCODE = 'SJIS'
$LOAD_PATH.unshift './lib'

require 'deft/select-template'
require 'test/unit'

class TC_SelectTemplate < Test::Unit::TestCase
  public
  def test_to_s
    Deft::Template.clear
    template( 'TEST/SELECT-TEMPLATE' ) do |template|
      template.template_type = Deft::SelectTemplate
      template.choices = ['CHOICE #1', 'CHOICE #1', 'CHOICE #3']
      template.default = 'CHOICE #1'
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
    assert /^Template:(.*)^Type:(.*)^Choices:(.*)^Default:(.*)^Description:(.*)^Description-ja:(.*)/m=~ Deft::Template['TEST/SELECT-TEMPLATE'].to_s
    assert_match /TEST\/SELECT-TEMPLATE/, $1, 'Template: の値がおかしい'
    assert_match /select/, $2, 'Type: の値がおかしい'
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