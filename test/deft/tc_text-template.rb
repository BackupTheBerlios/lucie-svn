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
  def test_to_s
    Deft::Template.clear
    template( 'TEST/TEXT-TEMPLATE' ) do |template|
      template.template_type = Deft::TextTemplate
      template.short_description = 'This is a short description'
      template.extended_description = (<<-DESCRIPTION)      
      This is a long description
      
      the abobe is a null line
      DESCRIPTION
      template.short_description_ja = '����͒Z���f�X�N���v�V�����ł�'
      template.extended_description_ja = (<<-DESCRIPTION_JA)      
      ����͒����f�X�N���v�V�����ł�
      
      ��͋�s�ł�
      DESCRIPTION_JA
    end
    assert /^Template:(.*)^Type:(.*)^Description:(.*)^Description-ja:(.*)/m=~ Deft::Template['TEST/TEXT-TEMPLATE'].to_s
    assert_match /TEST\/TEXT-TEMPLATE/, $1, 'Template: �̒l����������'
    assert_match /text/, $2, 'Type: �̒l����������'
    assert_match /This is a short description.*This is a long description.*the abobe is a null line/m, $3, 'Description: �̒l����������'
    assert_match /����͒Z���f�X�N���v�V�����ł�.*����͒����f�X�N���v�V�����ł�.*��͋�s�ł�/m, $4, 'Description-ja: �̒l����������'
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: