#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$KCODE = 'SJIS'
$LOAD_PATH.unshift './lib'

require 'lucie/note-template'
require 'test/unit'

class TC_NoteTemplate < Test::Unit::TestCase
  # �e�N���X�� Lucie::Template �ł��邱�Ƃ��e�X�g
  public
  def test_inheritance
    assert Lucie::NoteTemplate < Lucie::Template
  end
  
  public
  def test_to_s
    Lucie::Template.clear
    template( 'TEST/NOTE-TEMPLATE', Lucie::NoteTemplate ) do |template|
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
    
    assert /^Template:(.*)^Type:(.*)^Description:(.*)^Description-ja:(.*)/m=~ Lucie::Template['TEST/NOTE-TEMPLATE'].to_s
    assert_match /TEST\/NOTE-TEMPLATE/, $1, 'Template: �̒l����������'
    assert_match /note/, $2, 'Type: �̒l����������'
    assert_match /This is a short description.*This is a long description.*the abobe is a null line/m, $3, 'Description: �̒l����������'
    assert_match /����͒Z���f�X�N���v�V�����ł�.*����͒����f�X�N���v�V�����ł�.*��͋�s�ł�/m, $4, 'Description-ja: �̒l����������'
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: