#
# $Id$
#
# Author::   Yasuhito Takamiya (mailto:takamiya@matsulab.is.titech.ac.jp)
# Revision:: $LastChangedRevision$
# License::  GPL2

$LOAD_PATH.unshift './lib'

require 'lucie/string'
require 'test/unit'

class TC_String < Test::Unit::TestCase
  # �\�[�X�R�[�h�����񂹂ɂȂ邱�Ƃ��m�F
  public
  def test_unindent_auto
    assert_equal( (<<-EXPECTED_SOURCE_CODE), (<<-TEST_SOURCE_CODE).unindent_auto, "�������A���C���f���g(�I�[�g)�ł��Ȃ�" )
class Test
  public
  def this_is_da_test
    puts "HELLO"
  end
end
    EXPECTED_SOURCE_CODE
    class Test
      public
      def this_is_da_test
        puts "HELLO"
      end
    end
    TEST_SOURCE_CODE
  end
  
  # �X�y�[�X -> �^�u�̃e�X�g
  public
  def test_tabify
    assert_equal "\t ABCDE", '         ABCDE'.tabify, '�������^�r�t�@�C�ł��Ȃ�'
  end
  
  # �^�u -> �X�y�[�X�̃e�X�g
  public
  def test_untabify_tabstop_default
    assert_equal '        ABCDE', "\tABCDE".untabify, '�������A���^�r�t�@�C�ł��Ȃ�'
  end
  
  # �^�u -> �X�y�[�X�̃e�X�g (�^�u�X�g�b�v��ς���)
  public
  def test_untabify_tabstop_4
    assert_equal '    ABCDE', "\tABCDE".untabify( 4 ), '�������A���^�r�t�@�C�ł��Ȃ�'
  end
  
  # �^�u -> �X�y�[�X�̃e�X�g (�Â�����)
  public
  def test_untabify_complicated_string
    assert_equal 'ABCDE   FGHIJK  LMN', "ABCDE\tFGHIJK\tLMN".untabify( 4 ), '�������A���^�r�t�@�C�ł��Ȃ�'
  end
  
  # �A���C���f���g���Ă��ς�炸
  public
  def test_unindent_0
    assert_equal 'ABCDE', 'ABCDE'.unindent(0), "�������A���C���f���g����Ă��Ȃ�"
  end
  
  # �A���C���f���g���Ă��ς�炸 (�����s)
  public
  def test_unindent_0_multiple_lines
    assert_equal (<<-EXPECTED_STRING_UNINDENT_0), (<<-TEST_STRING_UNINDENT_0).unindent(0), "�������A���C���f���g����Ă��Ȃ�"
 ABCDE
 FGHIJ
 KLMNO
    EXPECTED_STRING_UNINDENT_0
 ABCDE
 FGHIJ
 KLMNO
    TEST_STRING_UNINDENT_0
  end
  
  # 4 �A���C���f���g
  public
  def test_unindent_4
    assert_equal ' ABCDE', '     ABCDE'.unindent(4), "�������A���C���f���g����Ă��Ȃ�"
  end
  
  # 4 �A���C���f���g (�����s)
  public
  def test_unindent_4_multiple_lines
    assert_equal (<<-EXPECTED_STRING_UNINDENT_4), (<<-TEST_STRING_UNINDENT_4).unindent(4), "�������A���C���f���g����Ă��Ȃ�"
  ABCDE
FGHIJ
  KLMNO    
    EXPECTED_STRING_UNINDENT_4
      ABCDE
    FGHIJ
      KLMNO    
    TEST_STRING_UNINDENT_4
  end
  
  # �^�u���܂߂� 3 �A���C���f���g 
  public
  def test_unindent_with_tab
    assert_equal "      ABCDE", "\t ABCDE".unindent(3), "�������A���C���f���g����Ă��Ȃ�"
  end
  
  # �^�u���܂߂� 3 �A���C���f���g (�����s) 
  public
  def test_unindent_with_tab_multiple_lines
    assert_equal (<<-EXPECTED_STRING_UNINDENT_WITH_TAB), (<<-TEST_STRING_UNINDENT_WITH_TAB).unindent(3), "�������A���C���f���g����Ă��Ȃ�"
       ABCDE
     FGHIJ
       KLMNO    
    EXPECTED_STRING_UNINDENT_WITH_TAB
\t  ABCDE
\tFGHIJ
\t  KLMNO    
    TEST_STRING_UNINDENT_WITH_TAB
  end
  
  # ���ɋ󔒂��Ȃ����߁Aminimum_indent �� 0
  public
  def test_minimum_indent_0
    assert_equal 0, 'ABCDE'.minimum_indent, "minimum_indent �̒l����������"
  end
  
  # ���ɋ󔒂��Ȃ����߁Aminimum_indent �� 0 (�����s)
  public
  def test_minimum_indent_0_multiple_lines
    assert_equal 0, (<<-TEST_STRING_MINIMUM_INDENT_0).minimum_indent, "minimum_indent �̒l����������"
ABCDE
FGHIJ
KLMNO
    TEST_STRING_MINIMUM_INDENT_0
  end
  
  # ���ɋ󔒂� 4 ����̂ŁAminimum_indent �� 4
  public
  def test_minimum_indent_4
    assert_equal 4, '    ABCDE'.minimum_indent, "minimum_indent �̒l����������"
  end
  
  # ���ɋ󔒂� 4 ����̂ŁAminimum_indent �� 4 (�����s)
  public
  def test_minimum_indent_4_multiple_lines
    assert_equal 4, (<<-TEST_STRING_MINIMUM_INDENT_4).minimum_indent, "minimum_indent �̒l����������"
      ABCDE
    FGHIJ
      KLMNO    
    TEST_STRING_MINIMUM_INDENT_4
  end
  
  # �^�u�X�g�b�v 8 �Ȃ̂ŁA���Ƀ^�u���������ꍇ minimum_indent �� 8
  public
  def test_minimum_indent_8
    assert_equal 8, "\tABCDE".minimum_indent, "minimum_indent �̒l����������"
  end
  
  # �^�u�X�g�b�v 8 �Ȃ̂ŁA���Ƀ^�u���������ꍇ minimum_indent �� 8 (�����s)
  public
  def test_minimum_indent_8_multiple_lines
    assert_equal 8, (<<-TEST_STRING_MINIMUM_INDENT_8).minimum_indent, "minimum_indent �̒l����������"
\t\tABCDE
\tFGHIJ
\t\tKLMNO
    TEST_STRING_MINIMUM_INDENT_8
  end
end

### Local variables:
### mode: Ruby
### indent-tabs-mode: nil
### End: