#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$KCODE = 'SJIS'
$LOAD_PATH.unshift './lib'

require 'lucie/boolean-template'
require 'test/unit'

class TC_BooleanTemplate < Test::Unit::TestCase
  # �e�N���X�� Lucie::Template �ł��邱�Ƃ��e�X�g
  public
  def test_inheritance
    assert Lucie::BooleanTemplate < Lucie::Template
  end
  
  public
  def test_to_s
    Lucie::Template.clear
    template( 'TEST/BOOLEAN-TEMPLATE', Lucie::BooleanTemplate ) do |template|
      template.default = 'no'
      template.description = (<<-DESCRIPTION)
      This is a short description
      This is a long description
      
      the abobe is a null line
      DESCRIPTION
      template.description_ja = (<<-DESCRIPTION_JA)
      ����͒Z���f�X�N���v�V�����ł�
      ����͒����f�X�N���v�V�����ł�
      
      ��͋�s�ł�
      DESCRIPTION_JA
    end
    
    assert /^Template:(.*)^Type:(.*)^Description:(.*)^Description-ja:(.*)/m=~ Lucie::Template['TEST/BOOLEAN-TEMPLATE'].to_s
    assert_match /TEST\/BOOLEAN-TEMPLATE/, $1, 'Template: �̒l����������'
    assert_match /boolean/, $2, 'Type: �̒l����������'
    assert_match /This is a short description.*This is a long description.*the abobe is a null line/m, $3, 'Description: �̒l����������'
    assert_match /����͒Z���f�X�N���v�V�����ł�.*����͒����f�X�N���v�V�����ł�.*��͋�s�ł�/m, $4, 'Description-ja: �̒l����������'
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End:
