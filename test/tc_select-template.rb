#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$KCODE = 'SJIS'
$LOAD_PATH.unshift './lib'

require 'lucie/select-template'
require 'test/unit'

class TC_SelectTemplate < Test::Unit::TestCase
  # �e�N���X�� Lucie::Template �ł��邱�Ƃ��e�X�g
  public
  def test_inheritance
    assert Lucie::SelectTemplate < Lucie::Template
  end
  
  public
  def test_to_s
    Lucie::Template.clear
    template( 'TEST/SELECT-TEMPLATE', Lucie::SelectTemplate ) do |template|
      template.choices = ['CHOICE #1', 'CHOICE #1', 'CHOICE #3']
      template.default = 'CHOICE #1'
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
    
    assert /^Template:(.*)^Type:(.*)^Choices:(.*)^Default:(.*)^Description:(.*)^Description-ja:(.*)/m=~ Lucie::Template['TEST/SELECT-TEMPLATE'].to_s
    assert_match /TEST\/SELECT-TEMPLATE/, $1, 'Template: �̒l����������'
    assert_match /select/, $2, 'Type: �̒l����������'
    assert_match /CHOICE #1, CHOICE #1, CHOICE #3/, $3, 'Choices: �̒l����������'
    assert_match /CHOICE #1/, $4, 'Default: �̒l����������'
    assert_match /This is a short description.*This is a long description.*the abobe is a null line/m, $5, 'Description: �̒l����������'
    assert_match /����͒Z���f�X�N���v�V�����ł�.*����͒����f�X�N���v�V�����ł�.*��͋�s�ł�/m, $6, 'Description-ja: �̒l����������'
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: