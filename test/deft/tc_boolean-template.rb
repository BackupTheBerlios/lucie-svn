#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'deft/boolean-template'
require 'test/unit'

class TC_BooleanTemplate < Test::Unit::TestCase
  public
  def test_to_s
    Deft::Template.clear
    template( 'TEST/BOOLEAN-TEMPLATE' ) do |template|
      template.template_type = Deft::BooleanTemplate
      template.default = 'true'
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
    assert /^Template:(.*)^Type:(.*)^Default:(.*)^Description:(.*)^Description-ja:(.*)/m=~ Deft::Template['TEST/BOOLEAN-TEMPLATE'].to_s
    assert_match /TEST\/BOOLEAN-TEMPLATE/, $1, 'Template: の値がおかしい'
    assert_match /boolean/, $2, 'Type: の値がおかしい'
    assert_match /true/, $3, 'Default: の値がおかしい'
    assert_match /This is a short description.*This is a long description.*the abobe is a null line/m, $4, 'Description: の値がおかしい'
    assert_match /これは短いデスクリプションです.*これは長いデスクリプションです.*上は空行です/m, $5, 'Description-ja: の値がおかしい'
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
