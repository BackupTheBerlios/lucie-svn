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
  # �e�N���X�� Deft::Template �ł��邱�Ƃ��e�X�g
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
      template.short_description_ja = '����͒Z���f�X�N���v�V�����ł�'
      template.extended_description_ja = (<<-DESCRIPTION_JA)      
      ����͒����f�X�N���v�V�����ł�
      
      ��͋�s�ł�
      DESCRIPTION_JA
    end
    assert /^Template:(.*)^Type:(.*)^Default:(.*)^Description:(.*)^Description-ja:(.*)/m=~ Deft::Template['TEST/STRING-TEMPLATE'].to_s
    assert_match /TEST\/STRING-TEMPLATE/, $1, 'Template: �̒l����������'
    assert_match /string/, $2, 'Type: �̒l����������'
    assert_match /default/, $3, 'Default: �̒l����������'
    assert_match /This is a short description.*This is a long description.*the abobe is a null line/m, $4, 'Description: �̒l����������'
    assert_match /����͒Z���f�X�N���v�V�����ł�.*����͒����f�X�N���v�V�����ł�.*��͋�s�ł�/m, $5, 'Description-ja: �̒l����������'
  end
end


### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
